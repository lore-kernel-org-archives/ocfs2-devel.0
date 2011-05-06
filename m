From: Tao Ma <tm@tao.ma>
Date: Fri, 06 May 2011 17:23:09 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Add batched discard support.
Message-ID: <4DC3BDFD.6090004@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	These are the patches for adding batched discard support in ocfs2. I
have tested it with xfstests 251 and it passed.

btw, I have also run some tests against it(bonnie++, postmark, ffsb and
fs_mark) and there are no big difference before and after the discard.

Regards,
Tao
