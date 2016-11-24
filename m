From: kbuild test robot <lkp@intel.com>
Date: Thu, 24 Nov 2016 19:49:57 +0800
Subject: [Ocfs2-devel] [PATCH 2/7] quota: Hold s_umount in exclusive
 mode when enabling / disabling quotas
In-Reply-To: <1479975162-24060-3-git-send-email-jack@suse.cz>
Message-ID: <201611241901.TEDfFV02%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

[auto build test ERROR on linus/master]
[also build test ERROR on v4.9-rc6 next-20161124]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jan-Kara/fs-Provide-function-to-get-superblock-with-exclusive-s_umount/20161124-192840
config: x86_64-randconfig-x013-201647 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   fs/quota/quota.c: In function 'SYSC_quotactl':
>> fs/quota/quota.c:883:7: error: implicit declaration of function 'quotactl_cmd_onoff' [-Werror=implicit-function-declaration]
     if (!quotactl_cmd_onoff(cmds))
          ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/quotactl_cmd_onoff +883 fs/quota/quota.c

   877			ret = PTR_ERR(sb);
   878			goto out;
   879		}
   880	
   881		ret = do_quotactl(sb, type, cmds, id, addr, pathp);
   882	
 > 883		if (!quotactl_cmd_onoff(cmds))
   884			drop_super(sb);
   885		else
   886			drop_super_exclusive(sb);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 26410 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161124/238f6683/attachment-0001.bin 
