From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 1 Dec 2011 18:29:34 -0800
Subject: [Ocfs2-devel] [PATCH 44/62] ocfs2: remove the second argument
 of k[un]map_atomic()
In-Reply-To: <4ED8322B.8010500@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	<1322371662-26166-45-git-send-email-amwang@redhat.com>
	<20111201201846.GF1495@noexit.corp.google.com>
	<4ED8322B.8010500@redhat.com>
Message-ID: <20111201182934.b8dd4c27.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

On Fri, 02 Dec 2011 10:04:27 +0800 Cong Wang <amwang@redhat.com> wrote:

> ___ 2011___12___02___ 04:18, Joel Becker ______:
> > On Sun, Nov 27, 2011 at 01:27:24PM +0800, Cong Wang wrote:
> >>
> >> Signed-off-by: Cong Wang<amwang@redhat.com>
> >
> > Acked-by: Joel Becker<jlbec@evilplan.org>
> >
> > I'm presuming you'll handle pushing this with the entire series.
> >
> 
> Yeah, I hope either Andrew can take all of them

waaay too many patches ;)

> or this can be merged into trivial tree.

I'd suggest you ask Stephen to add the git tree to -next.  Once it's
all suitably reviewed/acked/etc, and we're in the merge window, ask
Linus to pull it.
