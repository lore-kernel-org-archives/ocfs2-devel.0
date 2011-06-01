From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 31 May 2011 19:24:39 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: use proper little-endian bitops
In-Reply-To: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
References: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <20110601022438.GD29741@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

On Mon, May 30, 2011 at 09:58:05PM +0900, Akinobu Mita wrote:
> Using __test_and_{set,clear}_bit_le() with ignoring its return value
> can be replaced with __{set,clear}_bit_le().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: ocfs2-devel at oss.oracle.com

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

			http://www.jlbec.org/
			jlbec at evilplan.org
