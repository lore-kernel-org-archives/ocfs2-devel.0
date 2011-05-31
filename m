From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 31 May 2011 15:57:13 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: use proper little-endian bitops
In-Reply-To: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
References: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <20110531225713.GA10985@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

On Mon, May 30, 2011 at 09:58:05PM +0900, Akinobu Mita wrote:
> Using __test_and_{set,clear}_bit_le() with ignoring its return value
> can be replaced with __{set,clear}_bit_le().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: ocfs2-devel at oss.oracle.com

Looks reasonable to me...

Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Joel?
	--Mark

--
Mark Fasheh
