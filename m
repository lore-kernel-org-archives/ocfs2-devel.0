From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 22 Jun 2010 10:43:20 -0400
Subject: [Ocfs2-devel] [PATCH V3 3/8] Cleancache: core ops functions and
	configuration
In-Reply-To: <20100621231939.GA19505@ca-server1.us.oracle.com>
References: <20100621231939.GA19505@ca-server1.us.oracle.com>
Message-ID: <20100622144320.GA13324@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@Sun.COM, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com

On Mon, Jun 21, 2010 at 04:19:39PM -0700, Dan Magenheimer wrote:
> [PATCH V3 3/8] Cleancache: core ops functions and configuration
> 
> Cleancache core ops functions and configuration

NACK for code that just adds random hooks all over VFS and even
individual FS code, does an EXPORT_SYMBOL but doesn't actually introduce
any users.

And even if it had users these would have to be damn good ones given how
invasive it is.  So what exactly is this going to help us?  Given your
affiliation probably something Xen related, so some real use case would
be interesting as well instead of just making Xen suck slightly less.
