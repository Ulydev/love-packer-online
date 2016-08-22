
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
var PACKAGE_NAME = "/upload/1px-GgHRW/game.data";
var REMOTE_PACKAGE_BASE = "/upload/1px-GgHRW/game.data";
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
Module['FS_createPath']('/__MACOSX/assets', 'fonts', true, true);
Module['FS_createPath']('/__MACOSX/assets', 'images', true, true);
Module['FS_createPath']('/__MACOSX/assets/images', 'controls', true, true);
Module['FS_createPath']('/__MACOSX/assets/images', 'powerups', true, true);
Module['FS_createPath']('/__MACOSX/assets/images', 'skins', true, true);
Module['FS_createPath']('/__MACOSX/assets', 'sounds', true, true);
Module['FS_createPath']('/__MACOSX/assets/sounds', 'intro', true, true);
Module['FS_createPath']('/__MACOSX', 'include', true, true);
Module['FS_createPath']('/__MACOSX/include', 'hardoncollider', true, true);
Module['FS_createPath']('/__MACOSX/include', 'shaders', true, true);
Module['FS_createPath']('/__MACOSX/include', 'shine', true, true);
Module['FS_createPath']('/__MACOSX', 'scenes', true, true);
Module['FS_createPath']('/', 'assets', true, true);
Module['FS_createPath']('/assets', 'fonts', true, true);
Module['FS_createPath']('/assets', 'images', true, true);
Module['FS_createPath']('/assets/images', 'controls', true, true);
Module['FS_createPath']('/assets/images', 'powerups', true, true);
Module['FS_createPath']('/assets/images', 'skins', true, true);
Module['FS_createPath']('/assets', 'sounds', true, true);
Module['FS_createPath']('/assets/sounds', 'intro', true, true);
Module['FS_createPath']('/', 'include', true, true);
Module['FS_createPath']('/include', 'hardoncollider', true, true);
Module['FS_createPath']('/include', 'shaders', true, true);
Module['FS_createPath']('/include', 'shine', true, true);
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
              Module['removeRunDependency']('datafile_/Users/ulysse/Desktop/love-packer/.uploads/games/1px-GgHRW/game.data');

    };
    Module['addRunDependency']('datafile_/Users/ulysse/Desktop/love-packer/.uploads/games/1px-GgHRW/game.data');
  
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
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 197, "filename": "/conf.lua"}, {"audio": 0, "start": 197, "crunched": 0, "end": 2651, "filename": "/main.lua"}, {"audio": 0, "start": 2651, "crunched": 0, "end": 2771, "filename": "/__MACOSX/._include"}, {"audio": 0, "start": 2771, "crunched": 0, "end": 2891, "filename": "/__MACOSX/assets/._.DS_Store"}, {"audio": 0, "start": 2891, "crunched": 0, "end": 3011, "filename": "/__MACOSX/assets/._sounds"}, {"audio": 0, "start": 3011, "crunched": 0, "end": 3131, "filename": "/__MACOSX/assets/fonts/._.DS_Store"}, {"audio": 0, "start": 3131, "crunched": 0, "end": 3343, "filename": "/__MACOSX/assets/fonts/._gameboy.ttf"}, {"audio": 0, "start": 3343, "crunched": 0, "end": 3555, "filename": "/__MACOSX/assets/fonts/._intro.ttf"}, {"audio": 0, "start": 3555, "crunched": 0, "end": 3675, "filename": "/__MACOSX/assets/images/._.DS_Store"}, {"audio": 0, "start": 3675, "crunched": 0, "end": 3795, "filename": "/__MACOSX/assets/images/._capsule.png"}, {"audio": 0, "start": 3795, "crunched": 0, "end": 3915, "filename": "/__MACOSX/assets/images/._cursor.png"}, {"audio": 0, "start": 3915, "crunched": 0, "end": 4035, "filename": "/__MACOSX/assets/images/._fireparticle.png"}, {"audio": 0, "start": 4035, "crunched": 0, "end": 4155, "filename": "/__MACOSX/assets/images/._heart.png"}, {"audio": 0, "start": 4155, "crunched": 0, "end": 4275, "filename": "/__MACOSX/assets/images/._logo.png"}, {"audio": 0, "start": 4275, "crunched": 0, "end": 4395, "filename": "/__MACOSX/assets/images/._playWait.png"}, {"audio": 0, "start": 4395, "crunched": 0, "end": 4515, "filename": "/__MACOSX/assets/images/._progress.png"}, {"audio": 0, "start": 4515, "crunched": 0, "end": 4635, "filename": "/__MACOSX/assets/images/._ready.png"}, {"audio": 0, "start": 4635, "crunched": 0, "end": 4755, "filename": "/__MACOSX/assets/images/._selectioncursor.png"}, {"audio": 0, "start": 4755, "crunched": 0, "end": 4875, "filename": "/__MACOSX/assets/images/._tile.png"}, {"audio": 0, "start": 4875, "crunched": 0, "end": 4995, "filename": "/__MACOSX/assets/images/controls/._ai.png"}, {"audio": 0, "start": 4995, "crunched": 0, "end": 5115, "filename": "/__MACOSX/assets/images/controls/._gamepad.png"}, {"audio": 0, "start": 5115, "crunched": 0, "end": 5292, "filename": "/__MACOSX/assets/images/controls/._gamepadnum.png"}, {"audio": 0, "start": 5292, "crunched": 0, "end": 5412, "filename": "/__MACOSX/assets/images/controls/._keyboard.png"}, {"audio": 0, "start": 5412, "crunched": 0, "end": 5532, "filename": "/__MACOSX/assets/images/controls/._none.png"}, {"audio": 0, "start": 5532, "crunched": 0, "end": 5652, "filename": "/__MACOSX/assets/images/powerups/._gravity.png"}, {"audio": 0, "start": 5652, "crunched": 0, "end": 5772, "filename": "/__MACOSX/assets/images/powerups/._invicibility.png"}, {"audio": 0, "start": 5772, "crunched": 0, "end": 5892, "filename": "/__MACOSX/assets/images/powerups/._jetpack.png"}, {"audio": 0, "start": 5892, "crunched": 0, "end": 6012, "filename": "/__MACOSX/assets/images/powerups/._slowmo.png"}, {"audio": 0, "start": 6012, "crunched": 0, "end": 6132, "filename": "/__MACOSX/assets/images/skins/._.DS_Store"}, {"audio": 0, "start": 6132, "crunched": 0, "end": 6252, "filename": "/__MACOSX/assets/images/skins/._blue.png"}, {"audio": 0, "start": 6252, "crunched": 0, "end": 6372, "filename": "/__MACOSX/assets/images/skins/._boss.png"}, {"audio": 0, "start": 6372, "crunched": 0, "end": 6492, "filename": "/__MACOSX/assets/images/skins/._default.png"}, {"audio": 0, "start": 6492, "crunched": 0, "end": 6612, "filename": "/__MACOSX/assets/images/skins/._invisible.png"}, {"audio": 0, "start": 6612, "crunched": 0, "end": 6732, "filename": "/__MACOSX/assets/images/skins/._mario.png"}, {"audio": 0, "start": 6732, "crunched": 0, "end": 6852, "filename": "/__MACOSX/assets/images/skins/._vector.png"}, {"audio": 0, "start": 6852, "crunched": 0, "end": 6972, "filename": "/__MACOSX/assets/sounds/._.DS_Store"}, {"audio": 1, "start": 6972, "crunched": 0, "end": 7182, "filename": "/__MACOSX/assets/sounds/._bosscharge.wav"}, {"audio": 1, "start": 7182, "crunched": 0, "end": 7392, "filename": "/__MACOSX/assets/sounds/._bossfoot.wav"}, {"audio": 1, "start": 7392, "crunched": 0, "end": 7602, "filename": "/__MACOSX/assets/sounds/._bosshurt.wav"}, {"audio": 1, "start": 7602, "crunched": 0, "end": 7812, "filename": "/__MACOSX/assets/sounds/._bosskick.wav"}, {"audio": 1, "start": 7812, "crunched": 0, "end": 7932, "filename": "/__MACOSX/assets/sounds/._bossmusic.wav"}, {"audio": 1, "start": 7932, "crunched": 0, "end": 8142, "filename": "/__MACOSX/assets/sounds/._bossshoot.wav"}, {"audio": 1, "start": 8142, "crunched": 0, "end": 8262, "filename": "/__MACOSX/assets/sounds/._bossvoice.wav"}, {"audio": 1, "start": 8262, "crunched": 0, "end": 8747, "filename": "/__MACOSX/assets/sounds/._confirm.wav"}, {"audio": 1, "start": 8747, "crunched": 0, "end": 8957, "filename": "/__MACOSX/assets/sounds/._fade.wav"}, {"audio": 1, "start": 8957, "crunched": 0, "end": 9167, "filename": "/__MACOSX/assets/sounds/._hit.wav"}, {"audio": 0, "start": 9167, "crunched": 0, "end": 456638, "filename": "/__MACOSX/assets/sounds/._Icon"}, {"audio": 1, "start": 456638, "crunched": 0, "end": 457111, "filename": "/__MACOSX/assets/sounds/._jump.wav"}, {"audio": 1, "start": 457111, "crunched": 0, "end": 457231, "filename": "/__MACOSX/assets/sounds/._music.wav"}, {"audio": 1, "start": 457231, "crunched": 0, "end": 457441, "filename": "/__MACOSX/assets/sounds/._select.wav"}, {"audio": 1, "start": 457441, "crunched": 0, "end": 457651, "filename": "/__MACOSX/assets/sounds/._slot.wav"}, {"audio": 1, "start": 457651, "crunched": 0, "end": 457861, "filename": "/__MACOSX/assets/sounds/._smalljump.wav"}, {"audio": 1, "start": 457861, "crunched": 0, "end": 457981, "filename": "/__MACOSX/assets/sounds/._titlemusic.wav"}, {"audio": 1, "start": 457981, "crunched": 0, "end": 458164, "filename": "/__MACOSX/assets/sounds/._win.wav"}, {"audio": 1, "start": 458164, "crunched": 0, "end": 458284, "filename": "/__MACOSX/assets/sounds/intro/._heartbeat.wav"}, {"audio": 0, "start": 458284, "crunched": 0, "end": 458496, "filename": "/__MACOSX/include/._flux.lua"}, {"audio": 0, "start": 458496, "crunched": 0, "end": 458708, "filename": "/__MACOSX/include/._gamera.lua"}, {"audio": 0, "start": 458708, "crunched": 0, "end": 458920, "filename": "/__MACOSX/include/._hardoncollider"}, {"audio": 0, "start": 458920, "crunched": 0, "end": 459132, "filename": "/__MACOSX/include/._shine"}, {"audio": 0, "start": 459132, "crunched": 0, "end": 459344, "filename": "/__MACOSX/include/._tastytext.lua"}, {"audio": 0, "start": 459344, "crunched": 0, "end": 459556, "filename": "/__MACOSX/include/._utf8.lua"}, {"audio": 0, "start": 459556, "crunched": 0, "end": 459768, "filename": "/__MACOSX/include/hardoncollider/._class.lua"}, {"audio": 0, "start": 459768, "crunched": 0, "end": 459980, "filename": "/__MACOSX/include/hardoncollider/._gjk.lua"}, {"audio": 0, "start": 459980, "crunched": 0, "end": 460192, "filename": "/__MACOSX/include/hardoncollider/._hardoncollider-1.0-1.rockspec"}, {"audio": 0, "start": 460192, "crunched": 0, "end": 460404, "filename": "/__MACOSX/include/hardoncollider/._init.lua"}, {"audio": 0, "start": 460404, "crunched": 0, "end": 460616, "filename": "/__MACOSX/include/hardoncollider/._polygon.lua"}, {"audio": 0, "start": 460616, "crunched": 0, "end": 460828, "filename": "/__MACOSX/include/hardoncollider/._README"}, {"audio": 0, "start": 460828, "crunched": 0, "end": 461040, "filename": "/__MACOSX/include/hardoncollider/._shapes.lua"}, {"audio": 0, "start": 461040, "crunched": 0, "end": 461252, "filename": "/__MACOSX/include/hardoncollider/._spatialhash.lua"}, {"audio": 0, "start": 461252, "crunched": 0, "end": 461464, "filename": "/__MACOSX/include/hardoncollider/._vector-light.lua"}, {"audio": 0, "start": 461464, "crunched": 0, "end": 461584, "filename": "/__MACOSX/include/shaders/._.DS_Store"}, {"audio": 0, "start": 461584, "crunched": 0, "end": 461796, "filename": "/__MACOSX/include/shine/._boxblur.lua"}, {"audio": 0, "start": 461796, "crunched": 0, "end": 462008, "filename": "/__MACOSX/include/shine/._colorgradesimple.lua"}, {"audio": 0, "start": 462008, "crunched": 0, "end": 462220, "filename": "/__MACOSX/include/shine/._crt.lua"}, {"audio": 0, "start": 462220, "crunched": 0, "end": 462432, "filename": "/__MACOSX/include/shine/._desaturate.lua"}, {"audio": 0, "start": 462432, "crunched": 0, "end": 462644, "filename": "/__MACOSX/include/shine/._dmg.lua"}, {"audio": 0, "start": 462644, "crunched": 0, "end": 462856, "filename": "/__MACOSX/include/shine/._filmgrain.lua"}, {"audio": 0, "start": 462856, "crunched": 0, "end": 463068, "filename": "/__MACOSX/include/shine/._gaussianblur.lua"}, {"audio": 0, "start": 463068, "crunched": 0, "end": 463280, "filename": "/__MACOSX/include/shine/._glowsimple.lua"}, {"audio": 0, "start": 463280, "crunched": 0, "end": 463492, "filename": "/__MACOSX/include/shine/._godsray.lua"}, {"audio": 0, "start": 463492, "crunched": 0, "end": 463704, "filename": "/__MACOSX/include/shine/._init.lua"}, {"audio": 0, "start": 463704, "crunched": 0, "end": 463916, "filename": "/__MACOSX/include/shine/._LICENSE"}, {"audio": 0, "start": 463916, "crunched": 0, "end": 464128, "filename": "/__MACOSX/include/shine/._pixelate.lua"}, {"audio": 0, "start": 464128, "crunched": 0, "end": 464340, "filename": "/__MACOSX/include/shine/._posterize.lua"}, {"audio": 0, "start": 464340, "crunched": 0, "end": 464552, "filename": "/__MACOSX/include/shine/._README.md"}, {"audio": 0, "start": 464552, "crunched": 0, "end": 464764, "filename": "/__MACOSX/include/shine/._scanlines.lua"}, {"audio": 0, "start": 464764, "crunched": 0, "end": 464976, "filename": "/__MACOSX/include/shine/._separate_chroma.lua"}, {"audio": 0, "start": 464976, "crunched": 0, "end": 465188, "filename": "/__MACOSX/include/shine/._simpleglow.lua"}, {"audio": 0, "start": 465188, "crunched": 0, "end": 465400, "filename": "/__MACOSX/include/shine/._sketch.lua"}, {"audio": 0, "start": 465400, "crunched": 0, "end": 465612, "filename": "/__MACOSX/include/shine/._vignette.lua"}, {"audio": 0, "start": 465612, "crunched": 0, "end": 465732, "filename": "/__MACOSX/scenes/._.DS_Store"}, {"audio": 0, "start": 465732, "crunched": 0, "end": 481096, "filename": "/assets/.DS_Store"}, {"audio": 0, "start": 481096, "crunched": 0, "end": 487244, "filename": "/assets/fonts/.DS_Store"}, {"audio": 0, "start": 487244, "crunched": 0, "end": 493900, "filename": "/assets/fonts/gameboy.ttf"}, {"audio": 0, "start": 493900, "crunched": 0, "end": 514808, "filename": "/assets/fonts/intro.ttf"}, {"audio": 0, "start": 514808, "crunched": 0, "end": 520956, "filename": "/assets/images/.DS_Store"}, {"audio": 0, "start": 520956, "crunched": 0, "end": 540011, "filename": "/assets/images/capsule.png"}, {"audio": 0, "start": 540011, "crunched": 0, "end": 561238, "filename": "/assets/images/cursor.png"}, {"audio": 0, "start": 561238, "crunched": 0, "end": 579411, "filename": "/assets/images/fireparticle.png"}, {"audio": 0, "start": 579411, "crunched": 0, "end": 598089, "filename": "/assets/images/heart.png"}, {"audio": 0, "start": 598089, "crunched": 0, "end": 623650, "filename": "/assets/images/logo.png"}, {"audio": 0, "start": 623650, "crunched": 0, "end": 654019, "filename": "/assets/images/playWait.png"}, {"audio": 0, "start": 654019, "crunched": 0, "end": 677982, "filename": "/assets/images/progress.png"}, {"audio": 0, "start": 677982, "crunched": 0, "end": 698372, "filename": "/assets/images/ready.png"}, {"audio": 0, "start": 698372, "crunched": 0, "end": 716654, "filename": "/assets/images/selectioncursor.png"}, {"audio": 0, "start": 716654, "crunched": 0, "end": 734434, "filename": "/assets/images/tile.png"}, {"audio": 0, "start": 734434, "crunched": 0, "end": 753242, "filename": "/assets/images/controls/ai.png"}, {"audio": 0, "start": 753242, "crunched": 0, "end": 771866, "filename": "/assets/images/controls/gamepad.png"}, {"audio": 0, "start": 771866, "crunched": 0, "end": 789999, "filename": "/assets/images/controls/gamepadnum.png"}, {"audio": 0, "start": 789999, "crunched": 0, "end": 808621, "filename": "/assets/images/controls/keyboard.png"}, {"audio": 0, "start": 808621, "crunched": 0, "end": 827436, "filename": "/assets/images/controls/none.png"}, {"audio": 0, "start": 827436, "crunched": 0, "end": 845745, "filename": "/assets/images/powerups/gravity.png"}, {"audio": 0, "start": 845745, "crunched": 0, "end": 864276, "filename": "/assets/images/powerups/invicibility.png"}, {"audio": 0, "start": 864276, "crunched": 0, "end": 882857, "filename": "/assets/images/powerups/jetpack.png"}, {"audio": 0, "start": 882857, "crunched": 0, "end": 901185, "filename": "/assets/images/powerups/slowmo.png"}, {"audio": 0, "start": 901185, "crunched": 0, "end": 907333, "filename": "/assets/images/skins/.DS_Store"}, {"audio": 0, "start": 907333, "crunched": 0, "end": 936587, "filename": "/assets/images/skins/blue.png"}, {"audio": 0, "start": 936587, "crunched": 0, "end": 967966, "filename": "/assets/images/skins/boss.png"}, {"audio": 0, "start": 967966, "crunched": 0, "end": 987752, "filename": "/assets/images/skins/default.png"}, {"audio": 0, "start": 987752, "crunched": 0, "end": 1009881, "filename": "/assets/images/skins/invisible.png"}, {"audio": 0, "start": 1009881, "crunched": 0, "end": 1039189, "filename": "/assets/images/skins/mario.png"}, {"audio": 0, "start": 1039189, "crunched": 0, "end": 1059890, "filename": "/assets/images/skins/vector.png"}, {"audio": 0, "start": 1059890, "crunched": 0, "end": 1066038, "filename": "/assets/sounds/.DS_Store"}, {"audio": 1, "start": 1066038, "crunched": 0, "end": 1151280, "filename": "/assets/sounds/bosscharge.wav"}, {"audio": 1, "start": 1151280, "crunched": 0, "end": 1200328, "filename": "/assets/sounds/bossfoot.wav"}, {"audio": 1, "start": 1200328, "crunched": 0, "end": 1264200, "filename": "/assets/sounds/bosshurt.wav"}, {"audio": 1, "start": 1264200, "crunched": 0, "end": 1319622, "filename": "/assets/sounds/bosskick.wav"}, {"audio": 1, "start": 1319622, "crunched": 0, "end": 3372322, "filename": "/assets/sounds/bossmusic.wav"}, {"audio": 1, "start": 3372322, "crunched": 0, "end": 3469936, "filename": "/assets/sounds/bossshoot.wav"}, {"audio": 1, "start": 3469936, "crunched": 0, "end": 3714604, "filename": "/assets/sounds/bossvoice.wav"}, {"audio": 1, "start": 3714604, "crunched": 0, "end": 3732824, "filename": "/assets/sounds/confirm.wav"}, {"audio": 1, "start": 3732824, "crunched": 0, "end": 3807932, "filename": "/assets/sounds/fade.wav"}, {"audio": 1, "start": 3807932, "crunched": 0, "end": 3830528, "filename": "/assets/sounds/hit.wav"}, {"audio": 0, "start": 3830528, "crunched": 0, "end": 3830528, "filename": "/assets/sounds/Icon"}, {"audio": 1, "start": 3830528, "crunched": 0, "end": 3850848, "filename": "/assets/sounds/jump.wav"}, {"audio": 1, "start": 3850848, "crunched": 0, "end": 5262092, "filename": "/assets/sounds/music.wav"}, {"audio": 1, "start": 5262092, "crunched": 0, "end": 5277536, "filename": "/assets/sounds/select.wav"}, {"audio": 1, "start": 5277536, "crunched": 0, "end": 5314022, "filename": "/assets/sounds/slot.wav"}, {"audio": 1, "start": 5314022, "crunched": 0, "end": 5350856, "filename": "/assets/sounds/smalljump.wav"}, {"audio": 1, "start": 5350856, "crunched": 0, "end": 6762100, "filename": "/assets/sounds/titlemusic.wav"}, {"audio": 1, "start": 6762100, "crunched": 0, "end": 6816378, "filename": "/assets/sounds/win.wav"}, {"audio": 1, "start": 6816378, "crunched": 0, "end": 6913450, "filename": "/assets/sounds/intro/heartbeat.wav"}, {"audio": 0, "start": 6913450, "crunched": 0, "end": 6919598, "filename": "/include/.DS_Store"}, {"audio": 0, "start": 6919598, "crunched": 0, "end": 6932962, "filename": "/include/boss.lua"}, {"audio": 0, "start": 6932962, "crunched": 0, "end": 6935554, "filename": "/include/collisionmanager.lua"}, {"audio": 0, "start": 6935554, "crunched": 0, "end": 6935716, "filename": "/include/data.lua"}, {"audio": 0, "start": 6935716, "crunched": 0, "end": 6940827, "filename": "/include/flux.lua"}, {"audio": 0, "start": 6940827, "crunched": 0, "end": 6944501, "filename": "/include/gamepadmanager.lua"}, {"audio": 0, "start": 6944501, "crunched": 0, "end": 6950330, "filename": "/include/gamera.lua"}, {"audio": 0, "start": 6950330, "crunched": 0, "end": 6952128, "filename": "/include/gravity.lua"}, {"audio": 0, "start": 6952128, "crunched": 0, "end": 6952965, "filename": "/include/hue.lua"}, {"audio": 0, "start": 6952965, "crunched": 0, "end": 6954350, "filename": "/include/levelmanager.lua"}, {"audio": 0, "start": 6954350, "crunched": 0, "end": 6964645, "filename": "/include/levels.lua"}, {"audio": 0, "start": 6964645, "crunched": 0, "end": 6965060, "filename": "/include/load.lua"}, {"audio": 0, "start": 6965060, "crunched": 0, "end": 6966873, "filename": "/include/manager.lua"}, {"audio": 0, "start": 6966873, "crunched": 0, "end": 6969970, "filename": "/include/mapevents.lua"}, {"audio": 0, "start": 6969970, "crunched": 0, "end": 6996818, "filename": "/include/mapmanager.lua"}, {"audio": 0, "start": 6996818, "crunched": 0, "end": 7000740, "filename": "/include/player.lua"}, {"audio": 0, "start": 7000740, "crunched": 0, "end": 7004004, "filename": "/include/push.lua"}, {"audio": 0, "start": 7004004, "crunched": 0, "end": 7004018, "filename": "/include/shaders.lua"}, {"audio": 0, "start": 7004018, "crunched": 0, "end": 7008973, "filename": "/include/slam.lua"}, {"audio": 0, "start": 7008973, "crunched": 0, "end": 7011540, "filename": "/include/stateswitcher.lua"}, {"audio": 0, "start": 7011540, "crunched": 0, "end": 7026409, "filename": "/include/tastytext.lua"}, {"audio": 0, "start": 7026409, "crunched": 0, "end": 7029655, "filename": "/include/ui.lua"}, {"audio": 0, "start": 7029655, "crunched": 0, "end": 7037042, "filename": "/include/utf8.lua"}, {"audio": 0, "start": 7037042, "crunched": 0, "end": 7038947, "filename": "/include/util.lua"}, {"audio": 0, "start": 7038947, "crunched": 0, "end": 7042393, "filename": "/include/hardoncollider/class.lua"}, {"audio": 0, "start": 7042393, "crunched": 0, "end": 7047986, "filename": "/include/hardoncollider/gjk.lua"}, {"audio": 0, "start": 7047986, "crunched": 0, "end": 7048524, "filename": "/include/hardoncollider/hardoncollider-1.0-1.rockspec"}, {"audio": 0, "start": 7048524, "crunched": 0, "end": 7057615, "filename": "/include/hardoncollider/init.lua"}, {"audio": 0, "start": 7057615, "crunched": 0, "end": 7071148, "filename": "/include/hardoncollider/polygon.lua"}, {"audio": 0, "start": 7071148, "crunched": 0, "end": 7071266, "filename": "/include/hardoncollider/README"}, {"audio": 0, "start": 7071266, "crunched": 0, "end": 7083628, "filename": "/include/hardoncollider/shapes.lua"}, {"audio": 0, "start": 7083628, "crunched": 0, "end": 7088026, "filename": "/include/hardoncollider/spatialhash.lua"}, {"audio": 0, "start": 7088026, "crunched": 0, "end": 7091093, "filename": "/include/hardoncollider/vector-light.lua"}, {"audio": 0, "start": 7091093, "crunched": 0, "end": 7097241, "filename": "/include/shaders/.DS_Store"}, {"audio": 0, "start": 7097241, "crunched": 0, "end": 7102941, "filename": "/include/shaders/CRT.frag"}, {"audio": 0, "start": 7102941, "crunched": 0, "end": 7106003, "filename": "/include/shine/boxblur.lua"}, {"audio": 0, "start": 7106003, "crunched": 0, "end": 7107786, "filename": "/include/shine/colorgradesimple.lua"}, {"audio": 0, "start": 7107786, "crunched": 0, "end": 7112105, "filename": "/include/shine/crt.lua"}, {"audio": 0, "start": 7112105, "crunched": 0, "end": 7114182, "filename": "/include/shine/desaturate.lua"}, {"audio": 0, "start": 7114182, "crunched": 0, "end": 7119038, "filename": "/include/shine/dmg.lua"}, {"audio": 0, "start": 7119038, "crunched": 0, "end": 7121557, "filename": "/include/shine/filmgrain.lua"}, {"audio": 0, "start": 7121557, "crunched": 0, "end": 7124652, "filename": "/include/shine/gaussianblur.lua"}, {"audio": 0, "start": 7124652, "crunched": 0, "end": 7128214, "filename": "/include/shine/glowsimple.lua"}, {"audio": 0, "start": 7128214, "crunched": 0, "end": 7131382, "filename": "/include/shine/godsray.lua"}, {"audio": 0, "start": 7131382, "crunched": 0, "end": 7134967, "filename": "/include/shine/init.lua"}, {"audio": 0, "start": 7134967, "crunched": 0, "end": 7136039, "filename": "/include/shine/LICENSE"}, {"audio": 0, "start": 7136039, "crunched": 0, "end": 7141517, "filename": "/include/shine/pixelate.lua"}, {"audio": 0, "start": 7141517, "crunched": 0, "end": 7143948, "filename": "/include/shine/posterize.lua"}, {"audio": 0, "start": 7143948, "crunched": 0, "end": 7145743, "filename": "/include/shine/README.md"}, {"audio": 0, "start": 7145743, "crunched": 0, "end": 7149883, "filename": "/include/shine/scanlines.lua"}, {"audio": 0, "start": 7149883, "crunched": 0, "end": 7151970, "filename": "/include/shine/separate_chroma.lua"}, {"audio": 0, "start": 7151970, "crunched": 0, "end": 7155799, "filename": "/include/shine/simpleglow.lua"}, {"audio": 0, "start": 7155799, "crunched": 0, "end": 7158617, "filename": "/include/shine/sketch.lua"}, {"audio": 0, "start": 7158617, "crunched": 0, "end": 7160745, "filename": "/include/shine/vignette.lua"}, {"audio": 0, "start": 7160745, "crunched": 0, "end": 7166893, "filename": "/scenes/.DS_Store"}, {"audio": 0, "start": 7166893, "crunched": 0, "end": 7169321, "filename": "/scenes/game.lua"}, {"audio": 0, "start": 7169321, "crunched": 0, "end": 7170993, "filename": "/scenes/intro.lua"}, {"audio": 0, "start": 7170993, "crunched": 0, "end": 7174538, "filename": "/scenes/menu.lua"}], "remote_package_size": 7174538, "package_uuid": "add2bd1a-a1c7-4542-a316-b13088073164"});

})();
