From: Andrew Beekhof <beekhof@gmail.com>
Date: Fri, 14 Nov 2008 10:50:15 +0100
Subject: [Ocfs2-devel] [Pacemaker] [RFC] Splitting cluster.git into
	separate projects/trees
In-Reply-To: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
References: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
Message-ID: <26ef5e70811140150l7e789e8blc9df3de904a20a3c@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Top-posting...

#1 is what the current "situation" evolved from so I think its pretty
clear that despite the best of intentions, it doesn't work out (far
too easy for cross-dependancies to develop).

#2 - I share chrissie's feelings on this one ;-)

#3 - Thats got my vote - basically what we did with Pacemaker.

The biggest question here is do you want old versions of the split out
code to be buildable?

Obviously you'd keep the combined repo somewhere, but you may also
want to be able to build old versions from within the split-out repo.
If people don't want this, the split out repos _could_ be filtered
copies (smaller and only contains relevant history).

Just an idea - I don't have a strong opinion either way (For Pacemaker
I didn't filter, for the Pacemaker GUI I did).

Oh, and I'm assuming git can do this since Mercurial can (and it also
knows how to match the old and new commit IDs - since they'll
obviously change in the new repo)


On Fri, Nov 14, 2008 at 10:18, Fabio M. Di Nitto <fdinitto@redhat.com> wrote:
> Hi everybody,
>
> as discussed and agreed at the Cluster Summit we need to split our tree
> to make life easier in the long run (etc. etc.).
>
> We need to decide how we want to do it and there are different
> approaches to that. I was able to think of 3. There might be more and I
> might not have taken everything into consideration so comments and ideas
> are welcome.
>
> At this point we haven't really settled how many (sub) project will be
> created out of this split. This will come once we agree how to split.
>
> = first approach =
>
> We maintain cluster.git as single entity with all source code in one
> place. We change the build system in such a way each single component
> can be released standalone (similar to how it was done in the RHEL*
> branches).
>
> Pro:
>  - preserve current development model.
>  - allow release of separate tarball for each (sub) project.
>  - external users don't need to build the whole tree for one (sub)
> project.
>
> Cons:
>  - move all the burden to the build system (by duplicating tons of
> stuff, maybe solvable but needs investigation) and release manager.
>  - tagging for releases will require changes as it's not possible to tag
> only one (sub) project.
>
> = second approach =
>
> We maintain cluster.git as single entity. Each (sub) project would
> become a separate branch.
>
> So for example all the gnbd code will be branched into master-gnbd (and
> so on for all the others).
>
> Checking out one specific HEAD will only show the code for that project.
>
> Pro:
>  - cleaner look at the tree.
>  - partially preserve current development model (still easy to cherry
> pick changes between branches)
>  - external users don't need to build the whole tree.
>
> Cons:
>  - more expensive branch management.
>  - tagging for releases will require small changes.
>
> = third approach =
>
> We copy cluster.git N times for each (sub) project, clean the master
> branch to match only that (sub)project.
>
> Pro:
>  - very clean tree from checkout
>  - each (sub) project is really separated and will have its own
> identity.
>  - external users don't need to build the whole tree.
>  - easier to fine tune access to each single component (for example we
> can allow user foo to access dlm but not gfs... or whatever combination)
>
> Cons:
>  - more complex process to perform cherry-pick between branches.
>  - higher risk to commit fixes in one branch and forget in another.
>  - requires a lot more developer attention.
>
> Fabio
>
>
> _______________________________________________
> Pacemaker mailing list
> Pacemaker at clusterlabs.org
> http://list.clusterlabs.org/mailman/listinfo/pacemaker
>
