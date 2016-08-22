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

Meteor.startup(function () {

  UploadServer.init({
    tmpDir: path + "/.uploads/tmp",
    uploadDir: uploadDir,
    checkCreateDirectories: false,
    cacheTime: 100,
    maxPostSize: 60000000,
    maxFileSize: 50000000,
    getDirectory: function(fileInfo, formData) {
      if (!fileInfo.id) {
        fileInfo.title = fileInfo.name.slice(0, -5);
        fileInfo.id = fileInfo.title.replace(/[^\w\s]/gi, '') + "-" + generateId();
      }
      return "/" + fileInfo.id + "/";
    },
    finished: function(fileInfo, formFields) {
      console.log("upload finished, fileInfo ", fileInfo);
      console.log("upload finished, formFields: ", formFields);

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

      Uploads.insert(fileInfo);
    },
    cacheTime: 100,
    mimeTypes: {
        "love": "application/love"
    }
  });
});
