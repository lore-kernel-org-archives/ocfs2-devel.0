From: kbuild test robot <lkp@intel.com>
Date: Thu, 24 Nov 2016 20:55:38 +0800
Subject: [Ocfs2-devel] [PATCH 7/7] quota: Remove dqonoff_mutex
In-Reply-To: <1479975162-24060-8-git-send-email-jack@suse.cz>
Message-ID: <201611242025.AU3VeQo9%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.9-rc6 next-20161124]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jan-Kara/fs-Provide-function-to-get-superblock-with-exclusive-s_umount/20161124-192840
config: x86_64-randconfig-s0-11241854 (attached as .config)
compiler: gcc-4.4 (Debian 4.4.7-8) 4.4.7
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   fs/quota/dquot.c: In function 'dquot_enable':
   fs/quota/dquot.c:2431: warning: label 'load_quota' defined but not used
>> fs/quota/dquot.c:2407: warning: unused variable 'dqopt'
   fs/quota/dquot.o: warning: objtool: inode_reserved_space()+0x20: function has unreachable instruction

vim +/dqopt +2407 fs/quota/dquot.c

f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2401   * of individual quota flags
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2402   */
287a8095 fs/quota/dquot.c Christoph Hellwig 2010-05-19  2403  int dquot_enable(struct inode *inode, int type, int format_id,
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2404  		 unsigned int flags)
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2405  {
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2406  	struct super_block *sb = inode->i_sb;
f55abc0f fs/dquot.c       Jan Kara          2008-08-20 @2407  	struct quota_info *dqopt = sb_dqopt(sb);
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2408  
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2409  	/* Just unsuspend quotas? */
0f0dd62f fs/quota/dquot.c Christoph Hellwig 2010-05-19  2410  	BUG_ON(flags & DQUOT_SUSPENDED);
a0a83c50 fs/quota/dquot.c Jan Kara          2016-11-24  2411  	/* s_umount should be held in exclusive mode */
a0a83c50 fs/quota/dquot.c Jan Kara          2016-11-24  2412  	if (WARN_ON_ONCE(down_read_trylock(&sb->s_umount)))
a0a83c50 fs/quota/dquot.c Jan Kara          2016-11-24  2413  		up_read(&sb->s_umount);
0f0dd62f fs/quota/dquot.c Christoph Hellwig 2010-05-19  2414  
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2415  	if (!flags)
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2416  		return 0;
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2417  	/* Just updating flags needed? */
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2418  	if (sb_has_quota_loaded(sb, type)) {
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2419  		if (flags & DQUOT_USAGE_ENABLED &&
1d852305 fs/quota/dquot.c Jan Kara          2016-11-24  2420  		    sb_has_quota_usage_enabled(sb, type))
1d852305 fs/quota/dquot.c Jan Kara          2016-11-24  2421  			return -EBUSY;
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2422  		if (flags & DQUOT_LIMITS_ENABLED &&
1d852305 fs/quota/dquot.c Jan Kara          2016-11-24  2423  		    sb_has_quota_limits_enabled(sb, type))
1d852305 fs/quota/dquot.c Jan Kara          2016-11-24  2424  			return -EBUSY;
cc33412f fs/dquot.c       Jan Kara          2009-01-12  2425  		spin_lock(&dq_state_lock);
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2426  		sb_dqopt(sb)->flags |= dquot_state_flag(flags, type);
cc33412f fs/dquot.c       Jan Kara          2009-01-12  2427  		spin_unlock(&dq_state_lock);
1d852305 fs/quota/dquot.c Jan Kara          2016-11-24  2428  		return 0;
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2429  	}
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2430  
f55abc0f fs/dquot.c       Jan Kara          2008-08-20 @2431  load_quota:
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2432  	return vfs_load_quota_inode(inode, type, format_id, flags);
f55abc0f fs/dquot.c       Jan Kara          2008-08-20  2433  }
287a8095 fs/quota/dquot.c Christoph Hellwig 2010-05-19  2434  EXPORT_SYMBOL(dquot_enable);

:::::: The code at line 2407 was first introduced by commit
:::::: f55abc0fb9c3189de3da829adf3220322c0da43e quota: Allow to separately enable quota accounting and enforcing limits

:::::: TO: Jan Kara <jack@suse.cz>
:::::: CC: Mark Fasheh <mfasheh@suse.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 29004 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161124/b7758d62/attachment-0001.bin 
