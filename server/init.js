var exec = Npm.require('child_process').exec;

var path = process.env.PWD;
var uploadDir = path + "/.uploads/games";

var generateId = function ()
{
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
};

var handle = function (err, stdout, stderr) {
  if (err) {
    console.error(err);
    return;
  }
  console.log(stdout);
};

var escapeShell = function(cmd) {
  return '' + cmd.replace(/(["\s'$`\\])/g,'\\$1') + '';
};

Meteor.startup(function () {

  var maxSize = 50000000

  UploadServer.init({
    tmpDir: path + "/.uploads/tmp",
    uploadDir: uploadDir,
    checkCreateDirectories: false,
    cacheTime: 100,
    maxPostSize: maxSize + 10000000,
    maxFileSize: maxSize,
    getDirectory: function(fileInfo, formData) {
      if (!fileInfo.id) {
        fileInfo.title = fileInfo.name.slice(0, -5);
        fileInfo.id = fileInfo.title.replace(/[^A-Z0-9]/ig, "") + "-" + generateId();
      }
      return "/" + fileInfo.id + "/";
    },
    validateRequest: function(req) {
      if (req.headers["content-length"] > maxSize)
        return "File too big";
      return null;
    },
    validateFile: function(file, req) {
      if ((!file) || (file.name && file.name.length < 3 + 5) || (!file.name))
        return "Game name must be more than 3 characters long";
      if (file.name.slice(-5) != '.love')
        return "Not a .love file";
      return null;
    },
    finished: function(fileInfo, formData) {
      console.log("<---=====--->")
      console.log("fileInfo: ", fileInfo);
      console.log("formData: ", formData);

      fileInfo.path = escapeShell(fileInfo.path);
      console.log(fileInfo.path);

      var gamepath = path + "/.uploads/games";
      var gamedir = gamepath + fileInfo.path.slice(0, -5);
      var gamedata = gamepath + fileInfo.subDirectory + "game.data";
      var relativegamedata = "\\/upload\\/" + fileInfo.id + "\\/game.data";
      var gamejs = gamepath + fileInfo.subDirectory + "game.js";

      var command = "python " + path + "/.lovejs/emscripten/tools/file_packager.py ";
      command += gamedata + " ";
      command += "--preload " + gamedir + "/@/ --js-output=" + gamejs;

      exec("unzip " + gamepath + fileInfo.path + " -d " + gamedir, () => {
        console.log("Unzipped file");
        exec(command, () => {
          console.log("Generated game");
          exec("rm -rf " + gamedir, handle);
          console.log("Deleted tmp folder");
          exec("sed -i -e "
          + "'/var PACKAGE_NAME/s/.*/var PACKAGE_NAME = \"" + relativegamedata + "\"\;/;"
          + "/var REMOTE_PACKAGE_BASE/s/.*/var REMOTE_PACKAGE_BASE = \"" + relativegamedata + "\"\;/' " + gamejs, handle);
        });
      });

      fileInfo.views = 0;

      var date = new Date();
      fileInfo.createdAt = date;
      fileInfo.lastUpdated = date;
      fileInfo.private = formData.private == 'false' ? false : true;
      Uploads.insert(fileInfo);
    },
    cacheTime: 100,
    mimeTypes: {
        "love": "application/love"
    }
  });
});
