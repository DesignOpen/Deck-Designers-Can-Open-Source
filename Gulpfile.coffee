gulp = require('gulp')
stylus = require('gulp-stylus')
prefix = require('gulp-autoprefixer')
jade = require('gulp-jade')
imagemin = require('gulp-imagemin')
pngquant = require('imagemin-pngquant')
sourcemaps = require('gulp-sourcemaps')
browserSync = require('browser-sync')
reload = browserSync.reload
filter = require('gulp-filter')
browserify = require 'browserify'
source = require('vinyl-source-stream')
buffer = require('vinyl-buffer')
uglify = require('gulp-uglifyjs')
gulp.task 'css', ->
  gulp.src('src/css/*.styl').pipe(stylus(
    compress: true
    sourcemap:
      inline: true
      sourceRoot: '.'
      basePath: '_site/css')).pipe(sourcemaps.init(loadMaps: true)).pipe(prefix('> 1%')).pipe(sourcemaps.write('./', {})).pipe(gulp.dest('_site/css')).pipe(filter('**/*.css')).pipe reload(stream: true)
gulp.task 'js', ->
  browserify
    entries: ['./src/js/main.coffee']
    extensions: ['.coffee', '.js']
  .transform 'coffeeify'
  .bundle()
  # Pass desired file name to browserify with vinyl
  .pipe source 'main.js'
  # Start piping stream to tasks!
  .pipe gulp.dest '_site/js'
gulp.task 'html', ->
  gulp.src('src/*.jade').pipe(jade(pretty: true)).pipe(gulp.dest('_site')).pipe reload(stream: true)
gulp.task 'img', ->
  gulp.src('src/img/*').pipe(imagemin(
    progressive: true
    svgoPlugins: [
      { removeViewBox: false }
      { cleanupIDs: false }
    ]
    use: [ pngquant() ])).pipe(gulp.dest('./_site/img')).pipe reload(stream: true)
gulp.task 'copy', ->
  gulp.src('src/fonts/**').pipe gulp.dest('_site/fonts')
gulp.task 'browser-sync', ->
  browserSync
    server: baseDir: './_site'
    open: false
gulp.task 'default', [
  'css'
  'html'
  'img'
  'js'
  'copy'
  'browser-sync'
], ->
  gulp.watch 'src/css/*.styl', [ 'css' ]
  gulp.watch 'src/*.jade', [ 'html' ]
  gulp.watch 'src/js/**/*.coffee', [ 'js' ]
  gulp.watch 'src/js/*.coffee', [ 'js' ]
  gulp.watch 'src/img/*', [ 'img' ]
