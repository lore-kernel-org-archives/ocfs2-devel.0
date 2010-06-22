From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 22 Jun 2010 02:40:19 -0400
Subject: [Ocfs2-devel] [PATCH V3 0/8] Cleancache: overview
In-Reply-To: <20100621231809.GA11111@ca-server1.us.oracle.com>
References: <20100621231809.GA11111@ca-server1.us.oracle.com>
Message-ID: <20100622064019.GA22099@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com

What all this fails to explain is that this actually is useful for?

Your series adds lots of crappy code, entiely stupid interactions with a
handfull filesystems, but no actual users.
