
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
    var PACKAGE_NAME = '/Users/ulysse/Desktop/love-packer/.uploads/games/TurtleInvaders-gMaTv/game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
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
Module['FS_createPath']('/', 'characters', true, true);
Module['FS_createPath']('/characters', 'astro', true, true);
Module['FS_createPath']('/characters/astro', 'rip', true, true);
Module['FS_createPath']('/characters', 'becky', true, true);
Module['FS_createPath']('/characters', 'furious', true, true);
Module['FS_createPath']('/characters', 'gabe', true, true);
Module['FS_createPath']('/characters', 'hugo', true, true);
Module['FS_createPath']('/characters', 'idiot', true, true);
Module['FS_createPath']('/characters', 'polybius', true, true);
Module['FS_createPath']('/characters', 'qwerty', true, true);
Module['FS_createPath']('/characters', 'saulo', true, true);
Module['FS_createPath']('/characters', 'scuttles', true, true);
Module['FS_createPath']('/characters', 'turret', true, true);
Module['FS_createPath']('/characters', 'turtle', true, true);
Module['FS_createPath']('/', 'classes', true, true);
Module['FS_createPath']('/', 'graphics', true, true);
Module['FS_createPath']('/graphics', 'etc', true, true);
Module['FS_createPath']('/graphics', 'game', true, true);
Module['FS_createPath']('/graphics/game', 'shield', true, true);
Module['FS_createPath']('/graphics', 'intro', true, true);
Module['FS_createPath']('/graphics', 'mobile', true, true);
Module['FS_createPath']('/graphics', 'netplay', true, true);
Module['FS_createPath']('/', 'libraries', true, true);
Module['FS_createPath']('/', 'licenses', true, true);
Module['FS_createPath']('/', 'netplay', true, true);
Module['FS_createPath']('/', 'states', true, true);

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
              Module['removeRunDependency']('datafile_/Users/ulysse/Desktop/love-packer/.uploads/games/TurtleInvaders-gMaTv/game.data');

    };
    Module['addRunDependency']('datafile_/Users/ulysse/Desktop/love-packer/.uploads/games/TurtleInvaders-gMaTv/game.data');
  
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
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 173, "filename": "/conf.lua"}, {"audio": 0, "start": 173, "crunched": 0, "end": 1151, "filename": "/license.txt"}, {"audio": 0, "start": 1151, "crunched": 0, "end": 14339, "filename": "/main.lua"}, {"audio": 0, "start": 14339, "crunched": 0, "end": 14719, "filename": "/README.md"}, {"audio": 1, "start": 14719, "crunched": 0, "end": 20035, "filename": "/audio/blip.ogg"}, {"audio": 1, "start": 20035, "crunched": 0, "end": 230942, "filename": "/audio/boss.ogg"}, {"audio": 1, "start": 230942, "crunched": 0, "end": 240825, "filename": "/audio/bullet.ogg"}, {"audio": 1, "start": 240825, "crunched": 0, "end": 249216, "filename": "/audio/close.ogg"}, {"audio": 1, "start": 249216, "crunched": 0, "end": 257711, "filename": "/audio/drip.ogg"}, {"audio": 1, "start": 257711, "crunched": 0, "end": 301892, "filename": "/audio/evaporate.ogg"}, {"audio": 1, "start": 301892, "crunched": 0, "end": 315141, "filename": "/audio/explode.ogg"}, {"audio": 1, "start": 315141, "crunched": 0, "end": 352812, "filename": "/audio/gameover.ogg"}, {"audio": 1, "start": 352812, "crunched": 0, "end": 360546, "filename": "/audio/hurt1.ogg"}, {"audio": 1, "start": 360546, "crunched": 0, "end": 368108, "filename": "/audio/hurt2.ogg"}, {"audio": 1, "start": 368108, "crunched": 0, "end": 375970, "filename": "/audio/hurt3.ogg"}, {"audio": 1, "start": 375970, "crunched": 0, "end": 385505, "filename": "/audio/laser.ogg"}, {"audio": 1, "start": 385505, "crunched": 0, "end": 437092, "filename": "/audio/megacannon.ogg"}, {"audio": 1, "start": 437092, "crunched": 0, "end": 1585945, "filename": "/audio/menu.ogg"}, {"audio": 1, "start": 1585945, "crunched": 0, "end": 1595633, "filename": "/audio/oneup.ogg"}, {"audio": 1, "start": 1595633, "crunched": 0, "end": 1604024, "filename": "/audio/open.ogg"}, {"audio": 1, "start": 1604024, "crunched": 0, "end": 1616066, "filename": "/audio/pause.ogg"}, {"audio": 1, "start": 1616066, "crunched": 0, "end": 1624958, "filename": "/audio/shield.ogg"}, {"audio": 1, "start": 1624958, "crunched": 0, "end": 1636612, "filename": "/audio/tick.ogg"}, {"audio": 1, "start": 1636612, "crunched": 0, "end": 1670881, "filename": "/audio/wave.ogg"}, {"audio": 0, "start": 1670881, "crunched": 0, "end": 1670973, "filename": "/characters/astro/data.txt"}, {"audio": 0, "start": 1670973, "crunched": 0, "end": 1672760, "filename": "/characters/astro/ring.lua"}, {"audio": 0, "start": 1672760, "crunched": 0, "end": 1673673, "filename": "/characters/astro/ship.png"}, {"audio": 0, "start": 1673673, "crunched": 0, "end": 1715737, "filename": "/characters/astro/rip/shield.png"}, {"audio": 0, "start": 1715737, "crunched": 0, "end": 1718268, "filename": "/characters/becky/bilst.lua"}, {"audio": 0, "start": 1718268, "crunched": 0, "end": 1718838, "filename": "/characters/becky/biltz.png"}, {"audio": 0, "start": 1718838, "crunched": 0, "end": 1718986, "filename": "/characters/becky/data.txt"}, {"audio": 0, "start": 1718986, "crunched": 0, "end": 1721674, "filename": "/characters/becky/shield.png"}, {"audio": 0, "start": 1721674, "crunched": 0, "end": 1723530, "filename": "/characters/becky/ship.png"}, {"audio": 0, "start": 1723530, "crunched": 0, "end": 1723607, "filename": "/characters/furious/data.txt"}, {"audio": 0, "start": 1723607, "crunched": 0, "end": 1724072, "filename": "/characters/furious/fury.lua"}, {"audio": 0, "start": 1724072, "crunched": 0, "end": 1724570, "filename": "/characters/furious/shield.png"}, {"audio": 0, "start": 1724570, "crunched": 0, "end": 1725207, "filename": "/characters/furious/ship.png"}, {"audio": 0, "start": 1725207, "crunched": 0, "end": 1726184, "filename": "/characters/gabe/arkanoid.lua"}, {"audio": 0, "start": 1726184, "crunched": 0, "end": 1726279, "filename": "/characters/gabe/data.txt"}, {"audio": 0, "start": 1726279, "crunched": 0, "end": 1755501, "filename": "/characters/gabe/FjhNPs0.png"}, {"audio": 0, "start": 1755501, "crunched": 0, "end": 1780826, "filename": "/characters/gabe/shield.png"}, {"audio": 0, "start": 1780826, "crunched": 0, "end": 1782847, "filename": "/characters/gabe/ship.png"}, {"audio": 0, "start": 1782847, "crunched": 0, "end": 1782996, "filename": "/characters/hugo/data.txt"}, {"audio": 0, "start": 1782996, "crunched": 0, "end": 1785594, "filename": "/characters/hugo/guns.png"}, {"audio": 0, "start": 1785594, "crunched": 0, "end": 1792013, "filename": "/characters/hugo/portal.lua"}, {"audio": 0, "start": 1792013, "crunched": 0, "end": 1793555, "filename": "/characters/hugo/portal.png"}, {"audio": 0, "start": 1793555, "crunched": 0, "end": 1793735, "filename": "/characters/hugo/portalgrad.png"}, {"audio": 0, "start": 1793735, "crunched": 0, "end": 1812697, "filename": "/characters/hugo/shield.png"}, {"audio": 0, "start": 1812697, "crunched": 0, "end": 1815169, "filename": "/characters/hugo/ship.png"}, {"audio": 0, "start": 1815169, "crunched": 0, "end": 1815760, "filename": "/characters/hugo/shooting.png"}, {"audio": 0, "start": 1815760, "crunched": 0, "end": 1817144, "filename": "/characters/idiot/bubble.lua"}, {"audio": 0, "start": 1817144, "crunched": 0, "end": 1817223, "filename": "/characters/idiot/data.txt"}, {"audio": 0, "start": 1817223, "crunched": 0, "end": 1817798, "filename": "/characters/idiot/shield.png"}, {"audio": 0, "start": 1817798, "crunched": 0, "end": 1818483, "filename": "/characters/idiot/ship.png"}, {"audio": 0, "start": 1818483, "crunched": 0, "end": 1818577, "filename": "/characters/polybius/data.txt"}, {"audio": 0, "start": 1818577, "crunched": 0, "end": 1820608, "filename": "/characters/polybius/implode.lua"}, {"audio": 0, "start": 1820608, "crunched": 0, "end": 1823334, "filename": "/characters/polybius/shield.png"}, {"audio": 0, "start": 1823334, "crunched": 0, "end": 1824121, "filename": "/characters/polybius/ship.png"}, {"audio": 0, "start": 1824121, "crunched": 0, "end": 1824217, "filename": "/characters/qwerty/data.txt"}, {"audio": 0, "start": 1824217, "crunched": 0, "end": 1825423, "filename": "/characters/qwerty/quickstep.lua"}, {"audio": 0, "start": 1825423, "crunched": 0, "end": 1826573, "filename": "/characters/qwerty/shield.png"}, {"audio": 0, "start": 1826573, "crunched": 0, "end": 1827264, "filename": "/characters/qwerty/ship.png"}, {"audio": 0, "start": 1827264, "crunched": 0, "end": 1827344, "filename": "/characters/saulo/data.txt"}, {"audio": 0, "start": 1827344, "crunched": 0, "end": 1829926, "filename": "/characters/saulo/rockets.lua"}, {"audio": 0, "start": 1829926, "crunched": 0, "end": 1830429, "filename": "/characters/saulo/shield.png"}, {"audio": 0, "start": 1830429, "crunched": 0, "end": 1831063, "filename": "/characters/saulo/ship.png"}, {"audio": 0, "start": 1831063, "crunched": 0, "end": 1831155, "filename": "/characters/scuttles/data.txt"}, {"audio": 0, "start": 1831155, "crunched": 0, "end": 1832184, "filename": "/characters/scuttles/gecko.lua"}, {"audio": 0, "start": 1832184, "crunched": 0, "end": 1833172, "filename": "/characters/scuttles/shield.png"}, {"audio": 0, "start": 1833172, "crunched": 0, "end": 1834079, "filename": "/characters/scuttles/ship.png"}, {"audio": 0, "start": 1834079, "crunched": 0, "end": 1834986, "filename": "/characters/scuttles/shiprevive.png"}, {"audio": 0, "start": 1834986, "crunched": 0, "end": 1835294, "filename": "/characters/turret/bot.lua"}, {"audio": 0, "start": 1835294, "crunched": 0, "end": 1835327, "filename": "/characters/turret/data.txt"}, {"audio": 0, "start": 1835327, "crunched": 0, "end": 1835888, "filename": "/characters/turret/ship.png"}, {"audio": 0, "start": 1835888, "crunched": 0, "end": 1836002, "filename": "/characters/turtle/data.txt"}, {"audio": 0, "start": 1836002, "crunched": 0, "end": 1837751, "filename": "/characters/turtle/shield.png"}, {"audio": 0, "start": 1837751, "crunched": 0, "end": 1838516, "filename": "/characters/turtle/ship.png"}, {"audio": 0, "start": 1838516, "crunched": 0, "end": 1838792, "filename": "/characters/turtle/tank.lua"}, {"audio": 0, "start": 1838792, "crunched": 0, "end": 1840339, "filename": "/classes/achievement.lua"}, {"audio": 0, "start": 1840339, "crunched": 0, "end": 1840556, "filename": "/classes/barrier.lua"}, {"audio": 0, "start": 1840556, "crunched": 0, "end": 1845731, "filename": "/classes/bat.lua"}, {"audio": 0, "start": 1845731, "crunched": 0, "end": 1847709, "filename": "/classes/bullet.lua"}, {"audio": 0, "start": 1847709, "crunched": 0, "end": 1851444, "filename": "/classes/display.lua"}, {"audio": 0, "start": 1851444, "crunched": 0, "end": 1851887, "filename": "/classes/explosion.lua"}, {"audio": 0, "start": 1851887, "crunched": 0, "end": 1853160, "filename": "/classes/fizzle.lua"}, {"audio": 0, "start": 1853160, "crunched": 0, "end": 1856899, "filename": "/classes/megabat.lua"}, {"audio": 0, "start": 1856899, "crunched": 0, "end": 1858949, "filename": "/classes/megacannon.lua"}, {"audio": 0, "start": 1858949, "crunched": 0, "end": 1860582, "filename": "/classes/pausemenu.lua"}, {"audio": 0, "start": 1860582, "crunched": 0, "end": 1869249, "filename": "/classes/phoenix.lua"}, {"audio": 0, "start": 1869249, "crunched": 0, "end": 1876297, "filename": "/classes/player.lua"}, {"audio": 0, "start": 1876297, "crunched": 0, "end": 1877186, "filename": "/classes/powerup.lua"}, {"audio": 0, "start": 1877186, "crunched": 0, "end": 1880506, "filename": "/classes/raccoon.lua"}, {"audio": 0, "start": 1880506, "crunched": 0, "end": 1880964, "filename": "/classes/star.lua"}, {"audio": 0, "start": 1880964, "crunched": 0, "end": 1881389, "filename": "/classes/timer.lua"}, {"audio": 0, "start": 1881389, "crunched": 0, "end": 1939477, "filename": "/graphics/monofonto.ttf"}, {"audio": 0, "start": 1939477, "crunched": 0, "end": 1943182, "filename": "/graphics/etc/achievements.png"}, {"audio": 0, "start": 1943182, "crunched": 0, "end": 1954565, "filename": "/graphics/etc/error.png"}, {"audio": 0, "start": 1954565, "crunched": 0, "end": 1955243, "filename": "/graphics/game/bat.png"}, {"audio": 0, "start": 1955243, "crunched": 0, "end": 1955744, "filename": "/graphics/game/beam.png"}, {"audio": 0, "start": 1955744, "crunched": 0, "end": 1960084, "filename": "/graphics/game/boom.png"}, {"audio": 0, "start": 1960084, "crunched": 0, "end": 1966840, "filename": "/graphics/game/boombase.png"}, {"audio": 0, "start": 1966840, "crunched": 0, "end": 1968153, "filename": "/graphics/game/boss.png"}, {"audio": 0, "start": 1968153, "crunched": 0, "end": 1968687, "filename": "/graphics/game/explosion.png"}, {"audio": 0, "start": 1968687, "crunched": 0, "end": 1969042, "filename": "/graphics/game/fireballs.png"}, {"audio": 0, "start": 1969042, "crunched": 0, "end": 1969437, "filename": "/graphics/game/health.png"}, {"audio": 0, "start": 1969437, "crunched": 0, "end": 1971210, "filename": "/graphics/game/phoenix.png"}, {"audio": 0, "start": 1971210, "crunched": 0, "end": 1976642, "filename": "/graphics/game/powerupdisplay.png"}, {"audio": 0, "start": 1976642, "crunched": 0, "end": 1977919, "filename": "/graphics/game/powerups.png"}, {"audio": 0, "start": 1977919, "crunched": 0, "end": 1980254, "filename": "/graphics/game/risky.png"}, {"audio": 0, "start": 1980254, "crunched": 0, "end": 1980547, "filename": "/graphics/game/shield/1.png"}, {"audio": 0, "start": 1980547, "crunched": 0, "end": 1980833, "filename": "/graphics/game/shield/2.png"}, {"audio": 0, "start": 1980833, "crunched": 0, "end": 1981121, "filename": "/graphics/game/shield/3.png"}, {"audio": 0, "start": 1981121, "crunched": 0, "end": 1981474, "filename": "/graphics/game/shield/4.png"}, {"audio": 0, "start": 1981474, "crunched": 0, "end": 1981803, "filename": "/graphics/game/shield/5.png"}, {"audio": 0, "start": 1981803, "crunched": 0, "end": 1982140, "filename": "/graphics/game/shield/6.png"}, {"audio": 0, "start": 1982140, "crunched": 0, "end": 1982558, "filename": "/graphics/game/shield/7.png"}, {"audio": 0, "start": 1982558, "crunched": 0, "end": 1982989, "filename": "/graphics/game/shield/8.png"}, {"audio": 0, "start": 1982989, "crunched": 0, "end": 1983438, "filename": "/graphics/game/shield/9.png"}, {"audio": 0, "start": 1983438, "crunched": 0, "end": 1984671, "filename": "/graphics/intro/bubble.png"}, {"audio": 0, "start": 1984671, "crunched": 0, "end": 1986333, "filename": "/graphics/intro/intro.png"}, {"audio": 0, "start": 1986333, "crunched": 0, "end": 1998633, "filename": "/graphics/intro/potionlogo.png"}, {"audio": 0, "start": 1998633, "crunched": 0, "end": 1998983, "filename": "/graphics/mobile/back.png"}, {"audio": 0, "start": 1998983, "crunched": 0, "end": 1999308, "filename": "/graphics/mobile/exit.png"}, {"audio": 0, "start": 1999308, "crunched": 0, "end": 1999557, "filename": "/graphics/mobile/keyboard.png"}, {"audio": 0, "start": 1999557, "crunched": 0, "end": 1999967, "filename": "/graphics/mobile/options.png"}, {"audio": 0, "start": 1999967, "crunched": 0, "end": 2000303, "filename": "/graphics/netplay/serverexists.png"}, {"audio": 0, "start": 2000303, "crunched": 0, "end": 2005181, "filename": "/libraries/3ds.lua"}, {"audio": 0, "start": 2005181, "crunched": 0, "end": 2006913, "filename": "/libraries/character.lua"}, {"audio": 0, "start": 2006913, "crunched": 0, "end": 2007312, "filename": "/libraries/functions.lua"}, {"audio": 0, "start": 2007312, "crunched": 0, "end": 2011905, "filename": "/libraries/keyboard.lua"}, {"audio": 0, "start": 2011905, "crunched": 0, "end": 2018139, "filename": "/libraries/middleclass.lua"}, {"audio": 0, "start": 2018139, "crunched": 0, "end": 2025517, "filename": "/libraries/physics.lua"}, {"audio": 0, "start": 2025517, "crunched": 0, "end": 2026099, "filename": "/libraries/potion-compat.lua"}, {"audio": 0, "start": 2026099, "crunched": 0, "end": 2029455, "filename": "/libraries/util.lua"}, {"audio": 0, "start": 2029455, "crunched": 0, "end": 2030257, "filename": "/licenses/ctrulib-LICENSE"}, {"audio": 0, "start": 2030257, "crunched": 0, "end": 2066076, "filename": "/licenses/ctrulua-LICENSE"}, {"audio": 0, "start": 2066076, "crunched": 0, "end": 2067142, "filename": "/licenses/lovedos-LICENSE"}, {"audio": 0, "start": 2067142, "crunched": 0, "end": 2068281, "filename": "/licenses/lovepotion-license"}, {"audio": 0, "start": 2068281, "crunched": 0, "end": 2069381, "filename": "/licenses/lua-compat-5.2-LICENSE"}, {"audio": 0, "start": 2069381, "crunched": 0, "end": 2070451, "filename": "/licenses/lua-LICENSE"}, {"audio": 0, "start": 2070451, "crunched": 0, "end": 2071580, "filename": "/licenses/sf2dlib-LICENSE"}, {"audio": 0, "start": 2071580, "crunched": 0, "end": 2072709, "filename": "/licenses/sfillib-LICENSE"}, {"audio": 0, "start": 2072709, "crunched": 0, "end": 2073838, "filename": "/licenses/sftdlib-LICENSE"}, {"audio": 0, "start": 2073838, "crunched": 0, "end": 2077686, "filename": "/netplay/browser.lua"}, {"audio": 0, "start": 2077686, "crunched": 0, "end": 2085361, "filename": "/netplay/client.lua"}, {"audio": 0, "start": 2085361, "crunched": 0, "end": 2094395, "filename": "/netplay/lobby.lua"}, {"audio": 0, "start": 2094395, "crunched": 0, "end": 2100721, "filename": "/netplay/netplay.lua"}, {"audio": 0, "start": 2100721, "crunched": 0, "end": 2106234, "filename": "/states/charselect.lua"}, {"audio": 0, "start": 2106234, "crunched": 0, "end": 2108078, "filename": "/states/credits.lua"}, {"audio": 0, "start": 2108078, "crunched": 0, "end": 2116918, "filename": "/states/game.lua"}, {"audio": 0, "start": 2116918, "crunched": 0, "end": 2121449, "filename": "/states/highscore.lua"}, {"audio": 0, "start": 2121449, "crunched": 0, "end": 2123867, "filename": "/states/intro.lua"}, {"audio": 0, "start": 2123867, "crunched": 0, "end": 2134512, "filename": "/states/options.lua"}, {"audio": 0, "start": 2134512, "crunched": 0, "end": 2137892, "filename": "/states/title.lua"}], "remote_package_size": 2137892, "package_uuid": "0c624a2d-54f2-4296-8d24-25713abecadc"});

})();
