From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Thu, 10 Jun 2010 03:29:48 -0000
Subject: [Ocfs2-devel] [PATCH V2 2/7] Cleancache (was Transcendent
	Memory): core files
In-Reply-To: <4C1042E0.8080403@vflare.org>
References: <20100528173550.GA12219@ca-server1.us.oracle.com
	4C1042E0.8080403@vflare.org>
Message-ID: <c773d65b-e107-428c-ba6f-04d4ca9f8361@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ngupta@vflare.org
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com

> I just finished a rough (but working) implementation of in-kernel
> page cache compression backend (called zcache). During this work,
> I found some issues with cleancache, mostly related to (lack of)
> comments/documentation:

Great to hear!  And excellent feedback on the missing
documentation... I am working on this right now so your
feedback is very timely.

(documentation and funcition return values comments deleted
as I will fix all of them)

> > +
> > +static inline int cleancache_init_fs(size_t pagesize)
> > +
> 
>  - It seems that returning pool_id of 0 is considered as error
> condition (as it appears from deactivate_locked_super() changes).
> This seems weird; I think only negative pool_id should considered
> as error. Anyway, please add function comments for these.

Hmmm... this is a bug.  0 is a valid pool_id.  I'll fix it
for the next rev.

> Page cache compression was a long-pending project. I'm glad its
> coming into shape with the help of cleancache :)

Thanks!
Dan
