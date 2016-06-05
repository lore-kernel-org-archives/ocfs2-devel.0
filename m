From: kbuild test robot <lkp@intel.com>
Date: Mon, 6 Jun 2016 05:48:13 +0800
Subject: [Ocfs2-devel] [PATCH 01/45] block/fs/drivers: remove rw
 argument from submit_bio
In-Reply-To: <1465155145-10812-2-git-send-email-mchristi@redhat.com>
Message-ID: <201606060504.Kroz5DEN%fengguang.wu@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

[auto build test WARNING on v4.7-rc1]
[cannot apply to dm/for-next md/for-next next-20160603]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/v8-separate-operations-from-flags-in-the-bio-request-structs/20160606-040240
config: i386-allyesconfig (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   fs/ext4/crypto.c: In function 'ext4_encrypted_zeroout':
>> fs/ext4/crypto.c:442:25: warning: passing argument 1 of 'submit_bio_wait' makes pointer from integer without a cast [-Wint-conversion]
      err = submit_bio_wait(WRITE, bio);
                            ^
   In file included from include/linux/blkdev.h:19:0,
                    from fs/ext4/ext4.h:20,
                    from fs/ext4/ext4_extents.h:22,
                    from fs/ext4/crypto.c:37:
   include/linux/bio.h:476:12: note: expected 'struct bio *' but argument is of type 'long long unsigned int'
    extern int submit_bio_wait(struct bio *bio);
               ^~~~~~~~~~~~~~~
   fs/ext4/crypto.c:442:9: error: too many arguments to function 'submit_bio_wait'
      err = submit_bio_wait(WRITE, bio);
            ^~~~~~~~~~~~~~~
   In file included from include/linux/blkdev.h:19:0,
                    from fs/ext4/ext4.h:20,
                    from fs/ext4/ext4_extents.h:22,
                    from fs/ext4/crypto.c:37:
   include/linux/bio.h:476:12: note: declared here
    extern int submit_bio_wait(struct bio *bio);
               ^~~~~~~~~~~~~~~

vim +/submit_bio_wait +442 fs/ext4/crypto.c

b30ab0e0 Michael Halcrow 2015-04-12  426  			goto errout;
b30ab0e0 Michael Halcrow 2015-04-12  427  		}
b30ab0e0 Michael Halcrow 2015-04-12  428  		bio->bi_bdev = inode->i_sb->s_bdev;
36086d43 Theodore Ts'o   2015-10-03  429  		bio->bi_iter.bi_sector =
36086d43 Theodore Ts'o   2015-10-03  430  			pblk << (inode->i_sb->s_blocksize_bits - 9);
36086d43 Theodore Ts'o   2015-10-03  431  		ret = bio_add_page(bio, ciphertext_page,
b30ab0e0 Michael Halcrow 2015-04-12  432  				   inode->i_sb->s_blocksize, 0);
36086d43 Theodore Ts'o   2015-10-03  433  		if (ret != inode->i_sb->s_blocksize) {
36086d43 Theodore Ts'o   2015-10-03  434  			/* should never happen! */
36086d43 Theodore Ts'o   2015-10-03  435  			ext4_msg(inode->i_sb, KERN_ERR,
36086d43 Theodore Ts'o   2015-10-03  436  				 "bio_add_page failed: %d", ret);
36086d43 Theodore Ts'o   2015-10-03  437  			WARN_ON(1);
b30ab0e0 Michael Halcrow 2015-04-12  438  			bio_put(bio);
36086d43 Theodore Ts'o   2015-10-03  439  			err = -EIO;
b30ab0e0 Michael Halcrow 2015-04-12  440  			goto errout;
b30ab0e0 Michael Halcrow 2015-04-12  441  		}
b30ab0e0 Michael Halcrow 2015-04-12 @442  		err = submit_bio_wait(WRITE, bio);
36086d43 Theodore Ts'o   2015-10-03  443  		if ((err == 0) && bio->bi_error)
36086d43 Theodore Ts'o   2015-10-03  444  			err = -EIO;
95ea68b4 Theodore Ts'o   2015-05-31  445  		bio_put(bio);
b30ab0e0 Michael Halcrow 2015-04-12  446  		if (err)
b30ab0e0 Michael Halcrow 2015-04-12  447  			goto errout;
36086d43 Theodore Ts'o   2015-10-03  448  		lblk++; pblk++;
b30ab0e0 Michael Halcrow 2015-04-12  449  	}
b30ab0e0 Michael Halcrow 2015-04-12  450  	err = 0;

:::::: The code at line 442 was first introduced by commit
:::::: b30ab0e03407d2aa2d9316cba199c757e4bfc8ad ext4 crypto: add ext4 encryption facilities

:::::: TO: Michael Halcrow <mhalcrow@google.com>
:::::: CC: Theodore Ts'o <tytso@mit.edu>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
-------------- next part --------------
A non-text attachment was scrubbed...
Name: .config.gz
Type: application/octet-stream
Size: 54396 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160606/3abc7eab/attachment-0001.obj 
