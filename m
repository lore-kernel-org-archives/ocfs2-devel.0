From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 12 May 2009 20:11:29 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <4A019DA9.4050700@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
	<20090505213206.GM7835@mail.oracle.com>
	<20090506071531.GB6976@mit.edu> <4A019DA9.4050700@hp.com>
Message-ID: <20090512191129.GA10436@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: Theodore Tso <tytso@mit.edu>, joel.becker@oracle.com, Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

jim owens wrote:
> You ask why not use a 2-step "cowfilecopy" and "attrfilecopy"
> to do "snapfile"... because that is not an atomic snapshot.

Understood, no problem with that.  (Though it would be nice to have a
realistic example showing the atomicity being useful for a single file
snapshot).

Being able to create a _new file_ with the security attributes of an
existing file is sometimes useful too.  Lots of programs do that, of
course, but a lot of them get it wrong when non-traditional security
attributes are used.

reflink() followed by truncate() would be useful for that - and in
that case, returning EPERM if it can't clone the attributes would be
essential - because if a program which wants to copy "all the security
attributes" without the knowledge to parse them itself and set them in
the right order, then it won't have the code to check if they were
cloned reliably either.

> The security and "might not know about it" concerns are bogus:
> No extra visibility exists to future updates of the original
> file that would not exist without either snapfile or cowfilecopy.
> That BOTH point at your old data is no different than if root
> or raid was copying every disk block to permanent storage. If
> you write it, someone can have it later.

I agree with that _as long as_ reflink() does not permit you to clone
a file when you are not the owner and you don't have read access.

It looks like reflink() V4 does not permit in that case - good!

(A more precise statement of the rule is "as long as you could not
copy the file normally and then change its attributes to match what
reflink() produces").

That's different from link(), which _does_ allow links when you have
no read access and aren't the owner, but it always bumps i_nlink.
That's where I was coming from with the "might not know about it"
concern, because it looked like earlier reflink() proposals applied
the same weak permission checks as link().

V4 seems much better.

> So bottom line... I see no reason (except someone has to document)
> why we should not have 2 system calls since there are good uses
> and good definitions for both and the code is 99% identical.

I doubt if anyone cares deeply if there are two system calls or one
system call with a flag(*), since they are so similar.  The main thing
is having useful behaviours.

(*) Except for aesthetics.

I'm with the folks who think it's better for userspace to explicitly
request one behaviour or the other, rather than having reflink()
"automatically" decide for itself whether it will clone the attributes
or use new-file attributes.

The reason is because the "automatic" behaviour will certainly require
some applications to work around it, by guessing what it's going to do
before (which is difficult to do accurately), or checking what it did
afterwards.

That will be these applications:

   - Sometimes an app will want to clone the attributes, and tell the
     user "sorry, no" if that's not possible.  So the app will have to
     stat the file first, check the file owner against it's euid,
     reflink, then stat the resulting file afterwards and check what
     happened (because ownership might have changed between the first
     stat and reflink calls, changing reflink's behaviour from what it
     expected), and then call unlink if the wrong thing happend *and*
     it will still be wrong 1% of the time when the security model is
     not what the application expected.  Applications should not
     have to hard-code every known security model.  And linking then
     unlinking because you got it wrong is another security issue.

     "cp --cow -a" might be in this category, so would "rsync --cow -a"
     and generic backup applications.  I expect most applications
     wanting to copy exactly care about this.

   - Sometimes an app will want to warn the user if the attributes
     couldn't be cloned, but succeed in making the copy.  reflink() V4
     does that, but the app will have to check the new attributes against
     the old ones to know whether to warn, and then guess what errno
     would be appropriate.

     Maybe "cp --cow -a" will be like this.

   - Sometimes an app really just wants to copy a file with COW for
     efficient data sharing.  It will have to change the resulting
     attributes to "new file" attributes - and that will be wrong 1%
     of the time because it's not necessarily easy to get those
     attributes right, especially with non-standard security models.
     Even with traditional security, getting setgid-directory
     behaviour right is extremely difficult - because it depends on
     the filesystem's mount options among other things.  Basically
     "new file" attributes are something that should always be left to
     the kernel.

     While it might not be obvious when root would want to copy a file
     without preserving attributes with COW performance, the argument
     "I nearly always forget -p when writing cp" is arguing for "alias
     cp='cp -p'" in your /root/.profile, not for making the system
     call do it in a way you can't disable :-)

     Besides I can think of when you would want it: When running *any*
     shell script that you didn't write with the environment variable
     CP_USE_COW_WHEN_POSSIBLE_TO_SAVE_SPACE set ;-)

Now the opposite of "automatic" is the app requests whether to clone
attributes or use "new file" attributes.  In contrast to the above
problems, this doesn't cause any difficulty to applications, because
any app wanting the automatic choice can just do this:

     ret = reflink(a,b);
     if (ret == -1 && errno == EPERM)
         ret = cowlink(a,b);

Ok, that's not perfect because EPERM can mean other things.

Which brings us back to a flag ;-) like this:

     REFLINK_ATTR_CLONE                    (EPERM if can't clone attributes)
     REFLINK_ATTR_CLONE_IF_OWNER_OR_ROOT   (choose, as proposed in reflink V4)

One last annoyance.  If you're making a new file, then like open() you
need another argument, which is the new file's mode which is combined
with umask.  But not if you're cloning the attributes.

That's a good reason why there should be two functions for
applications.  The names reflink/cowlink (and reflinkat/cowlinkat)
make sense to me.  The cowlink functions have an extra mode argument,
like the last argument to open().

(They could all be one system call at the kernel level, but different
in libc, as is already planned for the reflink/reflinkat distinction.)

Oh, and please implement AT_SYMLINK_FOLLOW the same as link().

Thanks :-)
-- Jamie
