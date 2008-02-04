From: Tao Ma <tao.ma@oracle.com>
Date: Mon Feb  4 00:56:57 2008
Subject: [Ocfs2-devel] [patch 1/1] offline de-fragmentation tool
In-Reply-To: <47A67D89.2030403@oracle.com>
References: <47A67D89.2030403@oracle.com>
Message-ID: <47A6D304.8060604@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil,
    What do you think of this tools? It is good I think.

Thanks for your hard work, wengang.
It should really take you much time since the patch contains more than 
2000 lines. ;)
Have you written any design doc about it? Do you have any test script 
that can show us how this fantastic tool work?

But next time please use the git tree to get the latest ocfs2-tools 
source code and generate your patch against it, so that I can merge your 
code quickly in my tree. This time, since Joel has moved the include 
file to other places, I can't merge your patch successfully. So I only 
read your patch and give some comments.

wengang wang wrote:
> I wrote a user space tool to de-fragmentate global bitmap, hope this 
> tool is helpful.
Next time please send it to ocfs2-tools-devel since your patch only 
contains the modification to ocfs2-tools.
>
> for the case of storing non-DB data on ocfs2,  there are not several 
> very large file, but lots of relative small files.
> after a long time of using, --especially creating and deleting, the 
> global bitmap is split into fragments. so that even there is enough 
> free space(but not contiguous), creating a file may fail.
>
> there is a relative bug 6730723(on bugdb) though closed with "not 
> supported". and I have made a scenario that "df" show the partition 
> usage 51%, but on other nodes creating a file fails with "no space" 
> error.
>
> this offline tool, o2defrag, can make larger contiguous free bits on 
> global bitmap by moving data clusters of regular file and directories.
> it does:
> 1)  for each group, move data clusters on the group to the front of 
> the same group to make bigger free space at the end.
> 2)  for groups that has more free space, move data clusters to other 
> group(s) to make much more free space.
>     a)   firstly, it try to move data clusters to the group on which 
> there are data clusters of the same file. if no such group or no space 
> on these groups, goto b).
>     b)   move data clusters to a group on which there is no data 
> clusters of the same file.
> 3) does step 1) again.
>
> stuff changed by this tool is
> I)   moving of data clusters.
> II)  moving of corresponding bits in global bitmap.
> III) extent record in ocfs2_dinode block or extension block
>
> this tool doesn't merge or split extent records for now. and it's 
> nearly help nothing to fs performance.
> the feature to be added is trying to move all data clusters of a file 
> together as possible. so that accessing to file on ocfs2 can get 
> better performance.
>
> the patch is based on ocfs2-tool 1.2.6.  for compiling, needs to add a 
> symbolic link named "include" in o2defrag directory of 
> ../debugfs.ocfs2/include.
> usage is  "o2defrag <ocfs2 partition>"
>
>
> thanks,
> wengang.
>
> ------------------------------------------------------------------------
>
> diff -N -u -p -r ocfs2-tools-1.2.6.orig/libocfs2/chain.c ocfs2-tools-1.2.6/libocfs2/chain.c
> --- ocfs2-tools-1.2.6.orig/libocfs2/chain.c	2008-02-05 01:30:21.000000000 -0500
> +++ ocfs2-tools-1.2.6/libocfs2/chain.c	2008-02-05 02:00:53.000000000 -0500
> @@ -43,7 +43,33 @@ void ocfs2_swap_group_desc(struct ocfs2_
>  	gd->bg_parent_dinode = bswap_64(gd->bg_parent_dinode);
>  	gd->bg_blkno = bswap_64(gd->bg_blkno);
>  }
> +errcode_t ocfs2_read_group_desc2(ocfs2_filesys *fs, uint64_t blkno,
> +					char *gd_buf)
>   
You added so many *2 functions. And the biggest difference is that you 
don't allocate the spaces in it and read-write using the buffer given by 
the caller. I am not sure whether it is OK. Even if it is OK, you should 
put it into another patch, since it has no relationship with your 
o2defrag patch. And it also makes your patch smaller so that people can 
review it quickly.

> +struct o2_group_list{
> +	int group_size;		/* count of total bits of a group */
> +	int count;		/* count of groups */
> +	struct o2_group *head;	/* the first group in list */
> +	struct o2_group *last;  /* the last group in list */
> +};
> +
> +struct o2_file_list all_file_list;
> +struct o2_group_list all_group_list;
> +
> +/*
> +struct current_name{
> +	int current_layer;
> +	char *name[MAX_FILE_DEP+1];
> +};
> +
> +struct current_name current_name;
> +*/
>   
Could you please remove these unused code before you generate the patch? 
thanks.
> +
> +struct o2_modify_meta{
> +	uint64_t meta_blkno;		/* inode number of a fle */
> +	uint64_t old_data_blkno;	
> +	uint64_t new_data_blkno;
> +	int needs_free;			/* this is only for internal use */
> +	struct o2_modify_meta *next;
> +};
> +
> +static void * local_malloc(size_t size, int *needs_free)
> +{
> +	char *ret;
> +	ssize_t cache_size;
> +	int off;
> +
> +	cache_size  = sizeof(struct o2_modify_meta) * COUNT_OF_MODIFY_META;
> +
> +	if (memory_object.current_meta == COUNT_OF_MODIFY_META) {
> +		memory_object.buf = malloc(cache_size);
> +		if (!memory_object.buf) {
> +			printf("no mem\n");
>   
Use com_err like other ocfs2-tools please.
> +			return NULL;
> +		}
> +		memory_object.current_meta = 0;
> +	}
> +	
> +	if (memory_object.current_meta == 0) {
> +		*needs_free = 1;
> +	} else {
> +		*needs_free = 0;
> +	}
> +	off = sizeof(struct o2_modify_meta) * memory_object.current_meta;
> +	ret =  memory_object.buf + off;
> +	memory_object.current_meta ++;
> +
> +	return ret;
> +}
> +
> +static int worktree(char *basename, uint64_t blkno)
>   
> +	int res;
> +	char *buf = NULL;
> +	struct ocfs2_dinode *inode = NULL;
> +	struct o2_file *file = NULL;
> +	char type;
> +
> +	res = push_name(basename);
> +	if (res)
> +		return -1;
> +	res = ocfs2_malloc_block(gbls.fs->fs_io, &buf);
> +	if (res) {
> +		printf("ocfs2_malloc_block failed. %d\n", res);
> +		return -1;
> +	}
> +	
> +	res = ocfs2_read_inode2(gbls.fs, blkno, buf);
> +	if (res) {
> +		printf("ocfs2_read_inode error %d\n",res);
> +		goto ret1;
> +	}
> +	inode = (struct ocfs2_dinode *)buf;
> +	if (S_ISREG(inode->i_mode))
> +		type='f';
> +	else if (S_ISDIR(inode->i_mode))
> +		type='d';
> +	else {
> +		// ignore other type
> +		goto ret2;
> +	}
> +
> +	file = new_file(inode, type);
> +	if (!file) {
> +		goto ret1;
> +	}
> +	insert_file_to_list(file);
>   
You don't handle the file which has link_count > 2. So here you may 
insert it twice.
> +	res = access_one_node(inode, file);
> +	if (res)
> +		goto ret2;
> +
> +	if (file->type == 'd') {
> +		res = ocfs2_dir_iterate(gbls.fs, blkno, 0, NULL,
> +				do_with_childrens, NULL);
> +		if (res) {
> +			printf("ocfs2_dir_iterate failed. %d\n", res);
> +			goto ret2;
> +		}
> +	}
> +	goto ret1;
> +
> +ret2:	
> +	if (file && file->filename)
> +		free(file->filename);
> +	if (file)
> +		free(file);
> +ret1:
> +	if (buf)
> +		ocfs2_free(&buf);
> +	if (res) {
> +		pop_name();
> +	} else {
> +		res = pop_name();
> +	}
> +
> +	return res;
> +}
> +
> +/* find the record --ocfs2_extent_rec, which blkno is old_data_blkno, change blkno to 
> +new_data_blkno
> +*/
> +static inline int modify_file_meta(uint64_t file_blkno, uint64_t from_blkno,
> +					uint64_t to_blkno)
>   
Why go through the file once again? Since you have already iterate all 
the files, you may record the information there. So that you don't need 
to iterate it now the second time.
> +{
> +	struct ocfs2_dinode *inode;
> +	struct ocfs2_extent_list *el;
> +	int res;
> +
> +	if (!update_disk)
> +		return 0;
> +
> +	res = ocfs2_read_inode2(gbls.fs, file_blkno, buf_modify_file_meta);
> +	if (res) {
> +		printf("ocfs2_read_inode2 %lu, failed. %d\n",file_blkno, res);
> +		return -1;
> +	}
> +	inode = (struct ocfs2_dinode *)buf_modify_file_meta;
> +	el= &(inode->id2.i_list);
> +
> +	res = find_and_change_extent_rec(el, buf_modify_file_meta, file_blkno,
> +						1, from_blkno, to_blkno);
> +	if (res == 1) {
> +		printf("such meta block %lu not found\n", from_blkno);
> +	}
> +
> +	return res;
> +}
> +
> +/* move the clusters specified by file_group to front of the same group */
> +/* -1 -->error; 0 -->moved successfully; 1 -->no space */
> +static int move_file_group_on_group(struct o2_group *group,
> +				struct o2_file_group *file_group)
> +{
> +	struct ocfs2_group_desc *gd;
> +	int alloc_start_bits_off;
> +	int res;
> +	int first_free_bit;
> +	uint64_t fromblk, toblk;
> +	
> +	gd = group->gd;
> +	
> +	first_free_bit = get_first_free_bit(gd);
> +	if (-1 == first_free_bit) {	//group full
> +		res = 1;
> +		goto done;
> +	}
> +	
> +	if (file_group->off < first_free_bit) {
> +		res = 1;
> +		goto done;
> +	}
> +	
> +	/* clear in memory the bits owned by this file_group */
> +	clear_bits_on_group(file_group->off, file_group->count, gd);
> +
> +	/* try to find enough bits to move to */
> +	res = get_N_contig_free_bits(gd, file_group->count,
> +					&alloc_start_bits_off);
> +	if (res) {
> +		//no space
> +		set_bits_on_group(file_group->off, file_group->count, gd);
> +		res = 1;
> +		goto done;
> +	}
> +	
> +	if (alloc_start_bits_off > file_group->off)
>   
Here you need to handle alloc_start_bits_off == file_group->off.
> +	{
> +		// got a starting address later than the original
> +		clear_bits_on_group(alloc_start_bits_off, file_group->count, gd);
> +		set_bits_on_group(file_group->off, file_group->count, gd);
> +		res = 1;
> +		goto done;
> +	}
> +/* now copy data clusters from old place to new place one by one */
> +	fromblk = file_group->off<<get_shift_bits();
> +	toblk = alloc_start_bits_off<<get_shift_bits();
> +	if (!is_first_group_gd(group)) {
> +		fromblk += group->blkno;
> +		toblk += group->blkno;
> +	} 
> +
> +	res = copy_N_clusters(fromblk, toblk, file_group->count);
> +	if (res) {
> +		//error, won't continue to access.
> +		goto done;
> +	}
> +
> +	/* modify the meta data of the file on disk */
> +	if (!new_and_insert_meta(file_group->file->blkno, fromblk, toblk)) {
> +		//error, won't continue to access.
> +		res = -1;
> +		goto done;
> +	}
> +
> +	/* update the file group object */
> +	file_group->off = alloc_start_bits_off;
> +	file_group->blkno = file_group->off<<get_shift_bits();
> +	if (!is_first_group_gd(file_group->group)) {
> +		file_group->blkno += file_group->group->blkno;
> +	}
> +
> +done:
> +	return res;
> +}
> +
> +
> +/* move all data clusters of files in a group to the end of this group */
>   
You move to the beginning, not the end, it seems. ;)
> +/* for all groups, 
> +   for all files that have data-clusters on one of the groups,
> +   move the the data-clusters to front of this group, and move corresponding
> +   bits to the front of the bitmap in this group.
> +
> +   this moving is based on a ocfs2_extent_rec, no mering or spliting on ocfs2_extent_rec.
> +
> +   what's modified on disk:
> +   1) data-clusters copying, (while debugging, set the old clusters to 0)
> +   2) file meta-data. --modifying the ocfs2_extent_rec.e_blkno.
> +   3) clearing bits and setting bits on bitmap of that group.
> +*/
> +static int defrag1_move_data_to_front_on_all_group()
> +{
> +	int res;
> +	struct o2_group *group;
> +	struct o2_file_group *tmp;
> +	int first_free_bit;
> +
> +	group = all_group_list.head;
> +	printf("process in defrag1 ...\n");
> +	
> +	while ( group) {
> +		//move group 2 only for debug 
> +		printf("defrag1 working on group %d/%d...", group->group_num, all_group_list.count);
> +
> +		first_free_bit = get_first_free_bit(group->gd);
> +		if (-1 == first_free_bit) {
> +			//group full
> +			group = group->next;
> +			printf("done.\n");
> +			continue;
> +		}
> +		
> +		tmp = group->file_group_list.head;
> +		while (tmp) {
> +			res = move_file_group_on_group(group, tmp);
> +			if (res == -1) {
> +				printf("move_file_group_on_group failed. %d\n", res);
> +				return res;
> +			}
> +			tmp = tmp->next_in_group;
> +		}
> +		printf("done.\n");
> +		group = group->next;
> +	}
> +
> +	res = update_all_meta();
>   
You can't do it here. You really should do it immediately after your 
move the cluster in move_file_group_on_group. Otherwise if the system 
panic before this function, all the files' content is corrupted.

There are many trailing white spaces in your patch. So please remove 
them all.

anyway, thanks again for your work.
