
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
var PACKAGE_NAME = "/upload/pigring-0eEcj/game.data";
var REMOTE_PACKAGE_BASE = "/upload/pigring-0eEcj/game.data";
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', '__MACOSX', true, true);
Module['FS_createPath']('/__MACOSX', 'assets', true, true);
Module['FS_createPath']('/__MACOSX/assets', 'images', true, true);
Module['FS_createPath']('/__MACOSX/assets', 'sounds', true, true);
Module['FS_createPath']('/__MACOSX', 'include', true, true);
Module['FS_createPath']('/__MACOSX', 'lib', true, true);
Module['FS_createPath']('/', 'assets', true, true);
Module['FS_createPath']('/assets', 'images', true, true);
Module['FS_createPath']('/assets', 'sounds', true, true);
Module['FS_createPath']('/', 'include', true, true);
Module['FS_createPath']('/', 'lib', true, true);
Module['FS_createPath']('/', 'scenes', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_/Users/ulysse/Desktop/love-packer/.uploads/games/pigring-0eEcj/game.data');

    };
    Module['addRunDependency']('datafile_/Users/ulysse/Desktop/love-packer/.uploads/games/pigring-0eEcj/game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 252, "filename": "/conf.lua"}, {"audio": 0, "start": 252, "crunched": 0, "end": 2392, "filename": "/main.lua"}, {"audio": 0, "start": 2392, "crunched": 0, "end": 2614, "filename": "/__MACOSX/assets/._font.ttf"}, {"audio": 0, "start": 2614, "crunched": 0, "end": 2734, "filename": "/__MACOSX/assets/images/._background.png"}, {"audio": 0, "start": 2734, "crunched": 0, "end": 2854, "filename": "/__MACOSX/assets/images/._front.png"}, {"audio": 0, "start": 2854, "crunched": 0, "end": 2974, "filename": "/__MACOSX/assets/images/._pig.png"}, {"audio": 0, "start": 2974, "crunched": 0, "end": 3094, "filename": "/__MACOSX/assets/images/._zombiepig.png"}, {"audio": 1, "start": 3094, "crunched": 0, "end": 3304, "filename": "/__MACOSX/assets/sounds/._attack.wav"}, {"audio": 1, "start": 3304, "crunched": 0, "end": 3514, "filename": "/__MACOSX/assets/sounds/._ground.wav"}, {"audio": 1, "start": 3514, "crunched": 0, "end": 3724, "filename": "/__MACOSX/assets/sounds/._hit.wav"}, {"audio": 1, "start": 3724, "crunched": 0, "end": 3934, "filename": "/__MACOSX/assets/sounds/._jump.wav"}, {"audio": 1, "start": 3934, "crunched": 0, "end": 4156, "filename": "/__MACOSX/assets/sounds/._music.wav"}, {"audio": 0, "start": 4156, "crunched": 0, "end": 4276, "filename": "/__MACOSX/include/._.DS_Store"}, {"audio": 0, "start": 4276, "crunched": 0, "end": 4498, "filename": "/__MACOSX/lib/._anim8.lua"}, {"audio": 0, "start": 4498, "crunched": 0, "end": 4720, "filename": "/__MACOSX/lib/._gamera.lua"}, {"audio": 0, "start": 4720, "crunched": 0, "end": 4942, "filename": "/__MACOSX/lib/._lem.lua"}, {"audio": 0, "start": 4942, "crunched": 0, "end": 5164, "filename": "/__MACOSX/lib/._lue.lua"}, {"audio": 0, "start": 5164, "crunched": 0, "end": 5386, "filename": "/__MACOSX/lib/._push.lua"}, {"audio": 0, "start": 5386, "crunched": 0, "end": 11534, "filename": "/assets/.DS_Store"}, {"audio": 0, "start": 11534, "crunched": 0, "end": 50186, "filename": "/assets/font.ttf"}, {"audio": 0, "start": 50186, "crunched": 0, "end": 71516, "filename": "/assets/images/background.png"}, {"audio": 0, "start": 71516, "crunched": 0, "end": 90185, "filename": "/assets/images/front.png"}, {"audio": 0, "start": 90185, "crunched": 0, "end": 106144, "filename": "/assets/images/pig.png"}, {"audio": 0, "start": 106144, "crunched": 0, "end": 122035, "filename": "/assets/images/zombiepig.png"}, {"audio": 0, "start": 122035, "crunched": 0, "end": 128183, "filename": "/assets/sounds/.DS_Store"}, {"audio": 1, "start": 128183, "crunched": 0, "end": 167101, "filename": "/assets/sounds/attack.wav"}, {"audio": 1, "start": 167101, "crunched": 0, "end": 184677, "filename": "/assets/sounds/ground.wav"}, {"audio": 1, "start": 184677, "crunched": 0, "end": 211707, "filename": "/assets/sounds/hit.wav"}, {"audio": 1, "start": 211707, "crunched": 0, "end": 245099, "filename": "/assets/sounds/jump.wav"}, {"audio": 1, "start": 245099, "crunched": 0, "end": 1051575, "filename": "/assets/sounds/music.wav"}, {"audio": 0, "start": 1051575, "crunched": 0, "end": 1057723, "filename": "/include/.DS_Store"}, {"audio": 0, "start": 1057723, "crunched": 0, "end": 1059953, "filename": "/include/enemy.lua"}, {"audio": 0, "start": 1059953, "crunched": 0, "end": 1062465, "filename": "/include/player.lua"}, {"audio": 0, "start": 1062465, "crunched": 0, "end": 1063996, "filename": "/include/soundparsing.lua"}, {"audio": 0, "start": 1063996, "crunched": 0, "end": 1065776, "filename": "/include/ui.lua"}, {"audio": 0, "start": 1065776, "crunched": 0, "end": 1069639, "filename": "/include/util.lua"}, {"audio": 0, "start": 1069639, "crunched": 0, "end": 1075787, "filename": "/lib/.DS_Store"}, {"audio": 0, "start": 1075787, "crunched": 0, "end": 1084279, "filename": "/lib/anim8.lua"}, {"audio": 0, "start": 1084279, "crunched": 0, "end": 1089390, "filename": "/lib/flux.lua"}, {"audio": 0, "start": 1089390, "crunched": 0, "end": 1095219, "filename": "/lib/gamera.lua"}, {"audio": 0, "start": 1095219, "crunched": 0, "end": 1098019, "filename": "/lib/lem.lua"}, {"audio": 0, "start": 1098019, "crunched": 0, "end": 1100409, "filename": "/lib/lue.lua"}, {"audio": 0, "start": 1100409, "crunched": 0, "end": 1105386, "filename": "/lib/push.lua"}, {"audio": 0, "start": 1105386, "crunched": 0, "end": 1109755, "filename": "/lib/shack.lua"}, {"audio": 0, "start": 1109755, "crunched": 0, "end": 1114837, "filename": "/lib/slam.lua"}, {"audio": 0, "start": 1114837, "crunched": 0, "end": 1117415, "filename": "/lib/stateswitcher.lua"}, {"audio": 0, "start": 1117415, "crunched": 0, "end": 1123563, "filename": "/scenes/.DS_Store"}, {"audio": 0, "start": 1123563, "crunched": 0, "end": 1125945, "filename": "/scenes/game.lua"}], "remote_package_size": 1125945, "package_uuid": "278def9e-1434-4e68-8da8-2b3ef01de07d"});

})();
