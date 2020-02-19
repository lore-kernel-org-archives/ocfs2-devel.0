From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Wed, 19 Feb 2020 16:11:13 +0100
Subject: [Ocfs2-devel] [PATCH 00/44] Manually convert filesystem FS
	documents to ReST
In-Reply-To: <20200219023234.7b704acb@lwn.net>
References: <cover.1581955849.git.mchehab+huawei@kernel.org>
	<20200218040146.GM7778@bombadil.infradead.org>
	<20200218110406.098fdc09@kernel.org>
	<20200219023234.7b704acb@lwn.net>
Message-ID: <20200219161113.41add6e4@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Martin Brandenburg <martin@omnibond.com>, Jan Kara <jack@suse.cz>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Amir Goldstein <amir73il@gmail.com>, Bob Copeland <me@bobcopeland.com>, David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>, linux-mtd@lists.infradead.org, Ilya Dryomov <idryomov@gmail.com>, linux-afs@lists.infradead.org, Mike Marshall <hubcap@omnibond.com>, Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@infradead.org>, linux-nilfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, Sage Weil <sage@redhat.com>, Richard Weinberger <richard@nod.at>, Matthew Wilcox <willy@infradead.org>, Tyler Hicks <code@tyhicks.com>, cluster-devel@redhat.com, v9fs-developer@lists.sourceforge.net, Gao Xiang <xiang@kernel.org>, linux-ext4@vger.kernel.org, Salah

Em Wed, 19 Feb 2020 02:32:34 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 18 Feb 2020 11:04:06 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > Then, do a second pass at files outside the new directories (like
> > admin-guide), in order to better organize things, eventually splitting
> > some files into kAPI, uAPI and/or admin-guide.  
> 
> I'm looking forward to this phase!  Yes it is harder, and it often
> requires selling the idea to skeptical maintainers.  But that is how,
> IMO, we get from where we're at now to something closer to a set of
> coherent kernel docs.

Yeah, fully agreed that this is an important step.

I'm even more anxious for a third phase: filling the gaps. I'm pretty sure
that several important parts of the Kernel aren't properly represented
at Documentation.

Yet, before start writing new things, we should first organizing what we
already have, making them well-organized.

Cheers,
Mauro
