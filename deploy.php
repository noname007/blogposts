<?php
	if( ! is_dir("_site/.git"))
	{
		echo 'init';
		shell_exec("jekyll build && cd _site && git init && git remote add coding  git@git.coding.net:noname007/jekyll-web-blog.git && git add . && git commit -am\"xxxxxx\" &&  git checkout -b coding-pages");
	}
	echo 'buiding ...'.PHP_EOL;
	echo 'deploy...';
	shell_exec(" cd _site && git checkout coding-pages  && cd .. && jekyll build && cd _site && git add . && git commit -am\"xxxx\" && git push --force -u coding --all");
