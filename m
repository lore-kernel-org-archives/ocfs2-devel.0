From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 03 Mar 2009 16:44:45 +0100
Subject: [Ocfs2-devel] [PATCH 6/7] vfs: Set special lockdep map for dirs
 only if not set by fs
In-Reply-To: <20090302092338.GA23880@duck.suse.cz>
References: <1235679305-3920-1-git-send-email-jack@suse.cz>
	<1235679305-3920-2-git-send-email-jack@suse.cz>
	<1235679305-3920-3-git-send-email-jack@suse.cz>
	<1235679305-3920-4-git-send-email-jack@suse.cz>
	<1235679305-3920-5-git-send-email-jack@suse.cz>
	<1235679305-3920-6-git-send-email-jack@suse.cz>
	<1235679305-3920-7-git-send-email-jack@suse.cz>
	<1235680042.4948.590.camel@laptop>
	<20090302092338.GA23880@duck.suse.cz>
Message-ID: <1236095085.5330.4767.camel@laptop>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 2009-03-02 at 10:23 +0100, Jan Kara wrote:

>   Not that much - the difference is between "system directories" and normal
> directories. Currently we also have xattr i_mutex rank differently than
> normal i_mutex and this is exactly the same case. Only OCFS2 has much more
> such system files and also system directories so it's impractical to learn
> VFS about all of them...
>   But yes, probably I should update the changelog to say this so that
> a reader does not have to look up why we need it.

Just for my education, what is a system directory?

> > As to the patch, I'd rather you introduce a helper,
> > lockdep_match_class() or somesuch, if you can convince VFS folks that
> > what you're wanting to do is sane.
>   OK, sounds good. Does something like:
> #define lockdep_match_class(lock, key) lockdep_match_key(&(lock)->dep_map, key)
> 
> and
> 
> int lockdep_match_key(struct lockdep_map *lock, struct lock_class_key *key)
> {
> 	return lock->key == key;
> }
> 
>   Look fine to you? Thanks for opinion.

Yep, looks good, thanks!
