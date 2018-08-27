From: kbuild test robot <lkp@intel.com>
Date: Tue, 28 Aug 2018 04:49:51 +0800
Subject: [Ocfs2-devel] [PATCH V2] fix crash on
	ocfs2_duplicate_clusters_by_page
In-Reply-To: <20180827072634.23700-1-lchen@suse.com>
References: <20180827072634.23700-1-lchen@suse.com>
Message-ID: <201808280421.sYOtRYRM%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Larry,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.19-rc1 next-20180827]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_0day-2Dci_linux_commits_Larry-2DChen_fix-2Dcrash-2Don-2Docfs2-5Fduplicate-5Fclusters-5Fby-5Fpage_20180827-2D153559&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=mH9w6uCdFAFtAi_q8v5YEKIqG5fGOo-vui1uBvZ514k&s=ZofbLNoY_nluBSrgzRGsI0oWMvpcaaHcFdpgZUBZmqM&e=
config: x86_64-allmodconfig (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   fs/ocfs2/refcounttree.c:641:27: sparse: incorrect type in assignment (different base types)
   fs/ocfs2/refcounttree.c:641:27:    expected restricted __le32 [usertype] rf_generation
   fs/ocfs2/refcounttree.c:641:27:    got unsigned int
   fs/ocfs2/refcounttree.c:2050:35: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2050:35: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2260:25: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2260:25: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2428:23: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2428:23: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2966:53: sparse: too many arguments for function write_one_page
   fs/ocfs2/refcounttree.c:3261:27: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:3261:27: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:4553:32: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:4553:32: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:164:13: sparse: context imbalance in 'ocfs2_refcount_cache_lock' - wrong count at exit
   fs/ocfs2/refcounttree.c:171:13: sparse: context imbalance in 'ocfs2_refcount_cache_unlock' - unexpected unlock
   fs/ocfs2/refcounttree.c: In function 'ocfs2_duplicate_clusters_by_page':
>> fs/ocfs2/refcounttree.c:2966:11: error: too many arguments to function 'write_one_page'
        ret = write_one_page(page, 1);
              ^~~~~~~~~~~~~~
   In file included from include/linux/pagemap.h:8:0,
                    from include/linux/buffer_head.h:14,
                    from include/linux/jbd2.h:26,
                    from fs/ocfs2/ocfs2.h:39,
                    from fs/ocfs2/refcounttree.c:20:
   include/linux/mm.h:2365:18: note: declared here
    int __must_check write_one_page(struct page *page);
                     ^~~~~~~~~~~~~~

sparse warnings: (new ones prefixed by >>)

   fs/ocfs2/refcounttree.c:641:27: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] rf_generation @@    got  [usertype] rf_generation @@
   fs/ocfs2/refcounttree.c:641:27:    expected restricted __le32 [usertype] rf_generation
   fs/ocfs2/refcounttree.c:641:27:    got unsigned int
   fs/ocfs2/refcounttree.c:2050:35: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2050:35: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2260:25: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2260:25: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2428:23: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:2428:23: sparse: expression using sizeof(void)
>> fs/ocfs2/refcounttree.c:2966:53: sparse: too many arguments for function write_one_page
   fs/ocfs2/refcounttree.c:3261:27: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:3261:27: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:4553:32: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:4553:32: sparse: expression using sizeof(void)
   fs/ocfs2/refcounttree.c:164:13: sparse: context imbalance in 'ocfs2_refcount_cache_lock' - wrong count at exit
   fs/ocfs2/refcounttree.c:171:13: sparse: context imbalance in 'ocfs2_refcount_cache_unlock' - unexpected unlock
   fs/ocfs2/refcounttree.c: In function 'ocfs2_duplicate_clusters_by_page':
   fs/ocfs2/refcounttree.c:2966:11: error: too many arguments to function 'write_one_page'
        ret = write_one_page(page, 1);
              ^~~~~~~~~~~~~~
   In file included from include/linux/pagemap.h:8:0,
                    from include/linux/buffer_head.h:14,
                    from include/linux/jbd2.h:26,
                    from fs/ocfs2/ocfs2.h:39,
                    from fs/ocfs2/refcounttree.c:20:
   include/linux/mm.h:2365:18: note: declared here
    int __must_check write_one_page(struct page *page);
                     ^~~~~~~~~~~~~~

vim +/write_one_page +2966 fs/ocfs2/refcounttree.c

  2910	
  2911	int ocfs2_duplicate_clusters_by_page(handle_t *handle,
  2912					     struct inode *inode,
  2913					     u32 cpos, u32 old_cluster,
  2914					     u32 new_cluster, u32 new_len)
  2915	{
  2916		int ret = 0, partial;
  2917		struct super_block *sb = inode->i_sb;
  2918		u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
  2919		struct page *page;
  2920		pgoff_t page_index;
  2921		unsigned int from, to;
  2922		loff_t offset, end, map_end;
  2923		struct address_space *mapping = inode->i_mapping;
  2924	
  2925		trace_ocfs2_duplicate_clusters_by_page(cpos, old_cluster,
  2926						       new_cluster, new_len);
  2927	
  2928		offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
  2929		end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
  2930		/*
  2931		 * We only duplicate pages until we reach the page contains i_size - 1.
  2932		 * So trim 'end' to i_size.
  2933		 */
  2934		if (end > i_size_read(inode))
  2935			end = i_size_read(inode);
  2936	
  2937		while (offset < end) {
  2938			page_index = offset >> PAGE_SHIFT;
  2939			map_end = ((loff_t)page_index + 1) << PAGE_SHIFT;
  2940			if (map_end > end)
  2941				map_end = end;
  2942	
  2943			/* from, to is the offset within the page. */
  2944			from = offset & (PAGE_SIZE - 1);
  2945			to = PAGE_SIZE;
  2946			if (map_end & (PAGE_SIZE - 1))
  2947				to = map_end & (PAGE_SIZE - 1);
  2948	
  2949	retry:
  2950			page = find_or_create_page(mapping, page_index, GFP_NOFS);
  2951			if (!page) {
  2952				ret = -ENOMEM;
  2953				mlog_errno(ret);
  2954				break;
  2955			}
  2956	
  2957			/*
  2958			 * In case PAGE_SIZE <= CLUSTER_SIZE, This page
  2959			 * can't be dirtied before we CoW it out.
  2960			 */
  2961			if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
  2962				if (PageDirty(page)) {
  2963					/*
  2964					 * write_on_page will unlock the page on return
  2965					 */
> 2966					ret = write_one_page(page, 1);
  2967					goto retry;
  2968				}
  2969			}
  2970	
  2971			if (!PageUptodate(page)) {
  2972				ret = block_read_full_page(page, ocfs2_get_block);
  2973				if (ret) {
  2974					mlog_errno(ret);
  2975					goto unlock;
  2976				}
  2977				lock_page(page);
  2978			}
  2979	
  2980			if (page_has_buffers(page)) {
  2981				ret = walk_page_buffers(handle, page_buffers(page),
  2982							from, to, &partial,
  2983							ocfs2_clear_cow_buffer);
  2984				if (ret) {
  2985					mlog_errno(ret);
  2986					goto unlock;
  2987				}
  2988			}
  2989	
  2990			ocfs2_map_and_dirty_page(inode,
  2991						 handle, from, to,
  2992						 page, 0, &new_block);
  2993			mark_page_accessed(page);
  2994	unlock:
  2995			unlock_page(page);
  2996			put_page(page);
  2997			page = NULL;
  2998			offset = map_end;
  2999			if (ret)
  3000				break;
  3001		}
  3002	
  3003		return ret;
  3004	}
  3005	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://urldefense.proofpoint.com/v2/url?u=https-3A__lists.01.org_pipermail_kbuild-2Dall&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=mH9w6uCdFAFtAi_q8v5YEKIqG5fGOo-vui1uBvZ514k&s=BYHcWyKLr1fW_8jtNnOvxkwD3gg6U7UWG4f6P2VzpJU&e=                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 65708 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20180828/28cb244d/attachment-0001.bin 
