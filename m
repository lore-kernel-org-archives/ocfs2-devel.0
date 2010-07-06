From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 6 Jul 2010 16:58:20 -0400
Subject: [Ocfs2-devel] [PATCH V3 0/8] Cleancache: overview
In-Reply-To: <20100621231809.GA11111@ca-server1.us.oracle.com>
References: <20100621231809.GA11111@ca-server1.us.oracle.com>
Message-ID: <20100706205820.GB32627@phenom.dumpdata.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com

On Mon, Jun 21, 2010 at 04:18:09PM -0700, Dan Magenheimer wrote:
> [PATCH V3 0/8] Cleancache: overview

Dan,

Two comments:
 - Mention where one can get the implementor of the cleancache API.
   Either a link to where the patches reside or a git branch.
   If you need pointers on branch names:
   http://lkml.org/lkml/2010/6/7/269

-  Point out the presentation you did on this. It has an excellent
   overview of how this API works, and most importantly: a) images
   and b). performance numbers.

Otherwise, please consider all of these patches to have
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

tag.
