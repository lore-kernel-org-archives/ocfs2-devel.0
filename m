From: kbuild test robot <lkp@intel.com>
Date: Thu, 25 Feb 2016 08:54:08 +0800
Subject: [Ocfs2-devel] [PATCH 31/35] block,
	fs: remove old REQ definitions.
In-Reply-To: <1456343292-14535-32-git-send-email-mchristi@redhat.com>
Message-ID: <201602250839.tv8OqUSP%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mike,

[auto build test WARNING on next-20160224]
[cannot apply to dm/for-next v4.5-rc5 v4.5-rc4 v4.5-rc3 v4.5-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/separate-operations-from-flags-in-the-bio-request-structs/20160225-041726
config: i386-allmodconfig (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from include/linux/pagemap.h:8:0,
                    from fs/crypto/crypto.c:24:
   fs/crypto/crypto.c: In function 'fscrypt_zeroout_range':
>> include/linux/fs.h:198:19: warning: passing argument 1 of 'submit_bio_wait' makes pointer from integer without a cast [-Wint-conversion]
    #define RW_MASK   REQ_OP_WRITE
                      ^
   include/linux/fs.h:202:17: note: in expansion of macro 'RW_MASK'
    #define WRITE   RW_MASK
                    ^
   fs/crypto/crypto.c:325:25: note: in expansion of macro 'WRITE'
      err = submit_bio_wait(WRITE, bio);
                            ^
   In file included from fs/crypto/crypto.c:29:0:
   include/linux/bio.h:449:12: note: expected 'struct bio *' but argument is of type 'int'
    extern int submit_bio_wait(struct bio *bio);
               ^
   fs/crypto/crypto.c:325:9: error: too many arguments to function 'submit_bio_wait'
      err = submit_bio_wait(WRITE, bio);
            ^
   In file included from fs/crypto/crypto.c:29:0:
   include/linux/bio.h:449:12: note: declared here
    extern int submit_bio_wait(struct bio *bio);
               ^

vim +/submit_bio_wait +198 include/linux/fs.h

   182	 * READA		Used for read-ahead operations. Lower priority, and the
   183	 *			block layer could (in theory) choose to ignore this
   184	 *			request if it runs into resource problems.
   185	 * WRITE		A normal async write. Device will be plugged.
   186	 * WRITE_SYNC		Synchronous write. Identical to WRITE, but passes down
   187	 *			the hint that someone will be waiting on this IO
   188	 *			shortly. The write equivalent of READ_SYNC.
   189	 * WRITE_ODIRECT	Special case write for O_DIRECT only.
   190	 * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
   191	 * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
   192	 *			non-volatile media on completion.
   193	 * WRITE_FLUSH_FUA	Combination of WRITE_FLUSH and FUA. The IO is preceded
   194	 *			by a cache flush and data is guaranteed to be on
   195	 *			non-volatile media on completion.
   196	 *
   197	 */
 > 198	#define RW_MASK			REQ_OP_WRITE
   199	#define RWA_MASK		REQ_RAHEAD
   200	
   201	#define READ			REQ_OP_READ
   202	#define WRITE			RW_MASK
   203	#define READA			RWA_MASK
   204	
   205	#define READ_SYNC		REQ_SYNC
   206	#define WRITE_SYNC		(REQ_SYNC | REQ_NOIDLE)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/octet-stream
Size: 54079 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160225/97d040ba/attachment-0001.obj 
