From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 30 Oct 2008 16:32:34 -0700
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version
	2)
In-Reply-To: <20081030050254.GA1138@duck.suse.cz>
References: <12248859043309-git-send-email-jack@suse.cz>
	<20081029225832.GH15154@wotan.suse.de>
	<20081030050254.GA1138@duck.suse.cz>
Message-ID: <20081030233234.GL15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 06:02:54AM +0100, Jan Kara wrote:
> On Wed 29-10-08 15:58:32, Mark Fasheh wrote:
> > On Sat, Oct 25, 2008 at 12:05:04AM +0200, Jan Kara wrote:
> > > Hello,
> > > 
> > > the following patch series implements quotas for OCFS2. The patch
> > > series is based on:
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git linux-next
> > 
> > Great, thanks for posting these again.
> > 
> > > I've adressed Joel's comments, also node recovery is now fully working
> > > and I've fixed a few issues I found during my testing. So I'm currently
> > > not aware of any bugs. Please review, test, comment. Thanks.
> > 
> > How are we going to handle the vfs patches? I think realistically, they
> > should just all go into the merge_window branch of ocfs2.git along with the
> > Ocfs2 patches to add quoata support (and make use of the VFS features you
> > added). The VFS patches at least though, should probably get posted to
> > linux-fsdevel before I pick them up.
>   Yup. I don't know if you've noticed but I've already sent majority of VFS
> patches to Andrew Morton (linux-fsdevel CC'd) and they are in -mm. He had
> some valuable comments and other people also tripped onto various minor
> problems. I'm now incorporating all the changes and will send next version
> of the patchset when I'm done.

Oh, ok great!


> Finally, I think it's the easiest if the patches go to Linus via your
> tree. Probably I'll push via that path also 64-bit quota format patch
> although it has nothing to do with OCFS2, since otherwise we would have to
> synchronize unnecessarily.

Yeah, that sounds good. Once they're all ready, we'll move it over to
ocfs2.git. I certainly don't mind carrying any other patches for you either.
	--Mark

--
Mark Fasheh
