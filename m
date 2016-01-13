From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 13 Jan 2016 15:07:00 -0800
Subject: [Ocfs2-devel] [PATCH v3 1/4] ocfs2: export ocfs2_kset for
	online file check
In-Reply-To: <20160113230228.GJ819@wotan.suse.de>
References: <1451027779-6849-1-git-send-email-ghe@suse.com>
	<1451027779-6849-2-git-send-email-ghe@suse.com>
	<20160113230228.GJ819@wotan.suse.de>
Message-ID: <20160113150700.c9d703ab26038c1220d44bb7@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.de>
Cc: Gang He <ghe@suse.com>, rgoldwyn@suse.de, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, 13 Jan 2016 15:02:28 -0800 Mark Fasheh <mfasheh@suse.de> wrote:

> On Fri, Dec 25, 2015 at 03:16:16PM +0800, Gang He wrote:
> > Export ocfs2_kset object from ocfs2_stackglue kernel module,
> > then online file check code will create the related sysfiles
> > under ocfs2_kset object.
> > 
> > Signed-off-by: Gang He <ghe@suse.com>
> 
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
> 
> This was easy to review, though you might consider adding a note that we're
> exporting this because it's built in ocfs2_stackglue.ko.

I've updated the changelog to reflect that.  (copy-n-paste is still in
my skillset).
