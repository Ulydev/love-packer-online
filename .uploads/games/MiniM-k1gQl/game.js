
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
var PACKAGE_NAME = "/upload/MiniM-k1gQl/game.data";
var REMOTE_PACKAGE_BASE = "/upload/MiniM-k1gQl/game.data";
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
Module['FS_createPath']('/', 'audio', true, true);
Module['FS_createPath']('/', 'fonts', true, true);
Module['FS_createPath']('/', 'images', true, true);
Module['FS_createPath']('/', 'include', true, true);
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
              Module['removeRunDependency']('datafile_/Users/ulysse/Desktop/love-packer/.uploads/games/MiniM-k1gQl/game.data');

    };
    Module['addRunDependency']('datafile_/Users/ulysse/Desktop/love-packer/.uploads/games/MiniM-k1gQl/game.data');
  
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
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 176, "filename": "/conf.lua"}, {"audio": 0, "start": 176, "crunched": 0, "end": 2703, "filename": "/main.lua"}, {"audio": 0, "start": 2703, "crunched": 0, "end": 32651, "filename": "/Minim.icns"}, {"audio": 0, "start": 32651, "crunched": 0, "end": 132329, "filename": "/MiniM.ico"}, {"audio": 0, "start": 132329, "crunched": 0, "end": 138477, "filename": "/audio/.DS_Store"}, {"audio": 1, "start": 138477, "crunched": 0, "end": 154921, "filename": "/audio/click.wav"}, {"audio": 1, "start": 154921, "crunched": 0, "end": 200133, "filename": "/audio/gameOver.wav"}, {"audio": 1, "start": 200133, "crunched": 0, "end": 229103, "filename": "/audio/jump.wav"}, {"audio": 1, "start": 229103, "crunched": 0, "end": 1781820, "filename": "/audio/tsm.mp3"}, {"audio": 0, "start": 1781820, "crunched": 0, "end": 1787968, "filename": "/fonts/.DS_Store"}, {"audio": 0, "start": 1787968, "crunched": 0, "end": 2060564, "filename": "/fonts/atari.ttf"}, {"audio": 0, "start": 2060564, "crunched": 0, "end": 2066712, "filename": "/images/.DS_Store"}, {"audio": 0, "start": 2066712, "crunched": 0, "end": 2078264, "filename": "/images/ball.png"}, {"audio": 0, "start": 2078264, "crunched": 0, "end": 2084412, "filename": "/include/.DS_Store"}, {"audio": 0, "start": 2084412, "crunched": 0, "end": 2087439, "filename": "/include/cron.lua"}, {"audio": 0, "start": 2087439, "crunched": 0, "end": 2088349, "filename": "/include/enemy.lua"}, {"audio": 0, "start": 2088349, "crunched": 0, "end": 2093409, "filename": "/include/flux.lua"}, {"audio": 0, "start": 2093409, "crunched": 0, "end": 2098364, "filename": "/include/slam.lua"}, {"audio": 0, "start": 2098364, "crunched": 0, "end": 2098892, "filename": "/include/stateswitcher.lua"}, {"audio": 0, "start": 2098892, "crunched": 0, "end": 2105040, "filename": "/scenes/.DS_Store"}, {"audio": 0, "start": 2105040, "crunched": 0, "end": 2105849, "filename": "/scenes/credits.lua"}, {"audio": 0, "start": 2105849, "crunched": 0, "end": 2120714, "filename": "/scenes/game.lua"}, {"audio": 0, "start": 2120714, "crunched": 0, "end": 2123802, "filename": "/scenes/mainmenu.lua"}], "remote_package_size": 2123802, "package_uuid": "dc7f8c6a-fba2-4fb6-9717-e269424aab07"});

})();
