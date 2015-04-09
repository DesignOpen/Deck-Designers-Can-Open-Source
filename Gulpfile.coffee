var gulp = require('gulp');
var stylus = require('gulp-stylus');
var prefix = require('gulp-autoprefixer');
var jade = require('gulp-jade');
var imagemin = require('gulp-imagemin');
var pngcrush = require('imagemin-pngcrush');
var sourcemaps = require('gulp-sourcemaps');
var browserSync = require('browser-sync');
var reload = browserSync.reload;
var filter = require('gulp-filter');
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var buffer  = require('vinyl-buffer');
var uglify = require('gulp-uglifyjs');

gulp.task('css', function() {
  return gulp.src('src/css/*.styl').pipe(stylus({
    compress: true,
    sourcemap: {
      inline: true,
      sourceRoot: '.',
      basePath: '_site/css'
    }
  })).pipe(sourcemaps.init({
    loadMaps: true
  })).pipe(prefix("> 1%")).pipe(sourcemaps.write('./', {})).pipe(gulp.dest('_site/css')).pipe(filter('**/*.css')).pipe(reload({
    stream: true
  }));
});

gulp.task('js', function() {
  var bundler = browserify({
    entries: ['./src/js/main.js'],
    debug: true
  });

  var bundle = function() {
    return bundler
      .bundle()
      .pipe(source('bundle.js'))
      .pipe(buffer())
      .pipe(sourcemaps.init({loadMaps: true}))
        // Add transformation tasks to the pipeline here.
        // .pipe(uglify())
      .pipe(sourcemaps.write('./'))
      .pipe(gulp.dest('./_site/js/'))
      .pipe(reload({stream: true}));
  };

  return bundle();
});


gulp.task('html', function() {
  return gulp.src('src/*.jade')
    .pipe(jade({pretty: true}))
    .pipe(gulp.dest('_site'))
    .pipe(reload({stream: true}));
});

gulp.task('img', function() {
  return gulp.src('src/img/*').pipe(imagemin({
    progressive: true,
    svgoPlugins: [
      {
        removeViewBox: false
      }, {
        cleanupIDs: false
      }
    ],
    use: [pngcrush()]
  })).pipe(gulp.dest('./_site/img')).pipe(reload({
    stream: true
  }));
});

gulp.task('copy', function() {
  return gulp.src('src/fonts/**').pipe(gulp.dest('_site/fonts'));
});

gulp.task('browser-sync', function() {
  return browserSync({
    server: {
      baseDir: "./_site"
    },
    open: false
  });
});

gulp.task('default', ['css', 'html', 'img', 'js', 'copy', 'browser-sync'], function() {
  gulp.watch('src/css/*.styl', ['css']);
  gulp.watch('src/*.jade', ['html']);
  gulp.watch('src/js/**/*.js', ['js']);
  gulp.watch('src/js/*.js', ['js']);
  return gulp.watch('src/img/*', ['img']);
});
