From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Dec 2015 19:14:55 -0800
Subject: [Ocfs2-devel] [PATCH v3 0/4] Add online file check feature
In-Reply-To: <5683B938020000F900023B48@relay2.provo.novell.com>
References: <1451027779-6849-1-git-send-email-ghe@suse.com>
	<20151229134111.6e0817e4b540c1fdf42d0475@linux-foundation.org>
	<5683B938020000F900023B48@relay2.provo.novell.com>
Message-ID: <20151229191455.562f5f42.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <MFasheh@suse.com>, rgoldwyn@suse.de, linux-kernel@vger.kernel.org

On Tue, 29 Dec 2015 20:00:08 -0700 "Gang He" <ghe@suse.com> wrote:

> > This feature should be documented, please.  That means all pseudo-file
> > locations, all inputs, all outputs, expected behaviour etc etc.  Enough
> > info so that our users can usefully and fully use this feature in the
> > minimum time.  Documentation/filesystems/ocfs2.txt is the place for that.
> I ever sent out a document which describes this feature, I will modify that document sightly since sysfs interfaces have been adjusted,
> then send out to the list as a separated patch. Is it OK for you?

Sounds good, thanks.  The documentation is important because it permits
reviewers to understand the proposed interfaces, which need to be
nailed down before there's any point in looking at the implementation.
