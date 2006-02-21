From: Christoph Hellwig <hch@lst.de>
Date: Tue, 21 Feb 2006 19:39:06 +0100
Subject: [Ocfs2-devel] [PATCH 07/14] ocfs2: actually free hb set on
	cluster removal
In-Reply-To: <20060221165731.GA11903@locomotive.unixthugs.org>
References: <20060221165731.GA11903@locomotive.unixthugs.org>
Message-ID: <20060221183906.GB3068@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 21, 2006 at 11:57:31AM -0500, Jeff Mahoney wrote:
> 
>  This patch actually frees the hb set when the cluster dir is removed.

shouldn't this as a fix be first in the series before your new features?
In fact for future postings it would be nice if you sent a [PATCH x/n]
series for fixes, and a second [PATCH x/n series for features.
