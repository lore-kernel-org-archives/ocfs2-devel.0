From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 20 Jun 2012 16:18:23 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix NULL pointer dereferrence in
	__ocfs2_change_file_space
In-Reply-To: <1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
References: <20120620145659.a5fff5f6.akpm@linux-foundation.org>
	<1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
Message-ID: <20120620231823.GE17950@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, jlbec@evilplan.org, sunil.mushran@oracle.com

This should've been upstream a while ago  :/

On Wed, Jun 20, 2012 at 11:34:44PM +0100, Luis Henriques wrote:
> As ocfs2_fallocate() will invoke __ocfs2_change_file_space() with a NULL
> as the first parameter (file), it may trigger a NULL pointer dereferrence
> due to a missing check.  See http://bugs.launchpad.net/bugs/1006012.
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
