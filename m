From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 31 May 2011 16:07:02 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: use proper little-endian bitops
In-Reply-To: <20110531225713.GA10985@wotan.suse.de>
References: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
	<20110531225713.GA10985@wotan.suse.de>
Message-ID: <20110531230702.GE31742@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, May 31, 2011 at 03:57:13PM -0700, Mark Fasheh wrote:
> On Mon, May 30, 2011 at 09:58:05PM +0900, Akinobu Mita wrote:
> > Using __test_and_{set,clear}_bit_le() with ignoring its return value
> > can be replaced with __{set,clear}_bit_le().
> > 
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Cc: Joel Becker <jlbec@evilplan.org>
> > Cc: Mark Fasheh <mfasheh@suse.com>
> > Cc: ocfs2-devel at oss.oracle.com
> 
> Looks reasonable to me...
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> 
> Joel?

	No argument here.  Akinobu, do you want me to send it with ocfs2
fixes, or are you going to push it along?

Acked-by: Joel Becker <jlbec@evilplan.org>

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

			http://www.jlbec.org/
			jlbec at evilplan.org
