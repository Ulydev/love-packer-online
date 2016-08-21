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

      var command = "python " + path + "/.lovejs/emscripten/tools/file_packager.py ";
      command += gamepath + fileInfo.subDirectory + "game.data ";
      command += "--preload " + gamedir + "@/ --js-output=" + gamepath + fileInfo.subDirectory + "game.js"

      exec("unzip " + gamepath + fileInfo.path + " -d " + gamedir, () => {
        console.log("Unzipped file");
        exec(command, handle);
        console.log("Generated game");
      });
      /*
      exec("rm -rf " + gamedir, handle);
      console.log("Deleted tmp folder");
      */



      Uploads.insert(fileInfo);
    },
    cacheTime: 100,
    mimeTypes: {
        "love": "application/love"
    }
  });
});
