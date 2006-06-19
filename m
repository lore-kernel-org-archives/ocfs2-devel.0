From: Daniel Phillips <phillips@google.com>
Date: Mon, 19 Jun 2006 16:55:14 -0700
Subject: [Ocfs2-devel] [-mm PATCH] ocfs2: Shared writeable mmap
In-Reply-To: <20060619234643.GK3082@ca-server1.us.oracle.com>
References: <20060619234643.GK3082@ca-server1.us.oracle.com>
Message-ID: <44973962.4030309@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: dhowells@redhat.com, akpm@osdl.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> I finally got some time to sit down and implement an OCFS2 patch to make use
> of the ->page_mkwrite() callback added by David Howells' patch (named
> 'add-page_mkwrite-vm_operations-method.patch' in -mm). The patches, and an
> MPI program to test this can be found at:
> 
> http://kernel.org/pub/linux/kernel/people/mfasheh/ocfs2/mmap/
> 
> There's one bug however, which will cause the test program on one of the
> reading nodes to see stale data if it is run several times in a row against
> the same file. I have verified that the same thing works fine on a local
> file system (ext3). I'm not sure where the issue is, but I have a feeling
> I'm doing something bad in ocfs2_data_convert_worker(). Another possibility
> is that we missed a place to put the ->page_mkwrite callback.
> 
> Unfortunately, I have to step away from this patch for a bit as I have some
> higher priority issues to deal with :/ Luckily, it seems to be in a state
> which I think warrants it being pushed out to the public for general review,
> testing, etc. If anyone is interested, I'd also appreciate any advice or
> help regarding the bug -- my VM-foo is very weak :)
> 	--Mark

Hi Mark,

While this may be a great patch, you didn't actually explain what it does,
how it does it or why it does it.

Regards,

Daniel
