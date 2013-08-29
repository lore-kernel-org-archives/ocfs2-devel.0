From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 29 Aug 2013 12:26:48 -0700
Subject: [Ocfs2-devel] [PATCH] Use bigger nodestr to accomodate 32-bit
 node numbers
In-Reply-To: <521F3B44.9030107@suse.de>
References: <20130828041547.GA4404@shrek.cartoons>
	<521F19E1.8010600@oracle.com> <521F3B44.9030107@suse.de>
Message-ID: <20130829122648.c23f47e86a0a96ca771c1dc2@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 29 Aug 2013 07:15:00 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> > We have the corresponding debugging logic at ocfs2_dismount_volume(), which
> > defines the nodestr with the old size, it seems that this change would cause
> > potential buffer overflow while restore a bigger nodestr at it.
> 
> Yes, you are right. I will add the change in ocfs2_dismount_volume()  as 
> well. Sorry, I missed this.
> 
> Andrew: Would you prefer a combined patch or a separate one?
> 

It will need to be a separate patch, please.
