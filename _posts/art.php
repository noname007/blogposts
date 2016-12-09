#! /usr/bin/env php
<?php
	if($argc < 2){
		die("usage: ./".basename( __FILE__).' art-title [display title]'.PHP_EOL);
	}
	// date_default_timezone_set('prc');
	date_default_timezone_set('prc');
	$title = $argv[1];
	echo $filename = date('Y-m-d').'-'.$title.'.md',PHP_EOL;

	if($argc == 3){
		$title = $argv[2];
	}

	touch($filename);

	$date_time = date("Y-m-d H:i:s");

	$layout_header = <<<LAYOUT
---
layout: post
title:  "$title"
date:   $date_time +0800
categories: notes
published: true
---
* 目录
{:toc}

LAYOUT;

	file_put_contents($filename, $layout_header);
