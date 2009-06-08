From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 08 Jun 2009 12:07:21 -0700
Subject: [Ocfs2-devel] [SUGGESSTION 1/1] OCFS2: automatic dlm hash table
 size
In-Reply-To: <4A2CB464.5000103@oracle.com>
References: <200906080515.n585F9Mu012898@rgminet15.oracle.com>	<4A2CA7CC.7020407@oracle.com>
	<4A2CAE87.6070605@oracle.com>	<4A2CB249.5050304@oracle.com>
	<4A2CB464.5000103@oracle.com>
Message-ID: <4A2D6169.6060603@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> just increasing it works. I'm concerning memory waste for few inodes
> usage case. I don't know how large it is going to be in the future..
> even now, I just don't hope a memory waste though it's small though
> memory is cheap now... :)

So, we did discuss dynamic resizing of the lockres hash over a
year ago. At that time our hash was very small. 1 page in 1.2,
and 4 pages in 1.4-beta/mainline. At that time, we decided to
bump up the default in 1.4 to 64 pages.

Resizing requires a feedback loop. As in... lookup is taking too
much time. I am working on adding instrumentation that provides this
info. (The number of lockres' is too crude a stat.)

Once we have that, I would prefer we make the lock per chain instead
of a global. That will allow us to get more bang for the buck. Will
allow us to reduce the hashtable from 64 pages.

In the end, I am not yet sold on dynamic resizing. One data point is
that inode/dcache hashes are not dynamically resized.
