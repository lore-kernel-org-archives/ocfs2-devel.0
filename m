From: Tao Ma <tm@tao.ma>
Date: Mon, 23 May 2011 10:08:35 +0800
Subject: [Ocfs2-devel] [PATCH 0/3 V2] ocfs2: Add batched discard support.
Message-ID: <4DD9C1A3.5020005@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

changelog from v1 to v2:
integrated review advices from Sunil.

	These are the patches for adding batched discard support in ocfs2. I
have tested it with xfstests 251 and it passed.

btw, I have also run some tests against it(bonnie++, postmark, ffsb and
fs_mark) and there are no big difference before and after the discard.

Regards,
Tao
