From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 14 Dec 2015 11:18:27 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix recursive locking deadlock
In-Reply-To: <566E5BA5.5030308@oracle.com>
References: <1450058259-30682-1-git-send-email-junxiao.bi@oracle.com>
	<566EC6A8020000F90002219D@relay2.provo.novell.com>
	<566E5BA5.5030308@oracle.com>
Message-ID: <20151214191827.GF11072@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 14, 2015 at 02:03:17PM +0800, Junxiao Bi wrote:
> > Second, this issue can be reproduced in old Linux kernels (e.g. 3.16.7-24)? there should not be any regression issue? 
> Maybe just hard to reproduce, ocfs2 supports recursive locking.

In what sense? The DLM might but the FS should never be making use of such a
mechanism (it would be for userspace users).

We really can't add recursive locks without this getting rejected upstream.
There's a whole slew of reasons why we don't like those in the kernel.
	--Mark

--
Mark Fasheh
