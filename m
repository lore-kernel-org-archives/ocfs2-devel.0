From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Mon Aug  2 13:14:34 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B01812211@orsmsx410>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Another simple question.

How do I calculate the size of the volume from the superblock?

Do I just use the two fields:

u_int32_t s_blocksize_bits;         /* Blocksize for this fs */
u_int32_t s_clustersize_bits;       /* Clustersize for this fs */

What is the formula to use?

Thanks,
John
