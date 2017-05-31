From: kbuild test robot <lkp@intel.com>
Date: Wed, 31 May 2017 23:50:27 +0800
Subject: [Ocfs2-devel] [PATCH 27/28] ext4: xattr inode deduplication
In-Reply-To: <20170531081517.11438-27-tahsin@google.com>
Message-ID: <201705312307.CulhbaOe%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tahsin,

[auto build test ERROR on ext4/dev]
[also build test ERROR on next-20170531]
[cannot apply to v4.12-rc3]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Tahsin-Erdogan/ext4-xattr-in-inode-support/20170531-214310
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
config: i386-defconfig (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   fs/built-in.o: In function `ext4_xattr_inode_get':
>> xattr.c:(.text+0xb8818): undefined reference to `crc32c'
   fs/built-in.o: In function `ext4_xattr_set_entry':
   xattr.c:(.text+0xb9614): undefined reference to `crc32c'

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/gzip
Size: 26190 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170531/4cc8d48d/attachment-0001.bin 
