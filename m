From: Larry Chen <lchen@suse.com>
Date: Wed, 11 Apr 2018 19:31:26 +0800
Subject: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
In-Reply-To: <HE1PR0401MB2538C6A144D96B2B567B1710EDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
References: <HE1PR0401MB25389DFE7BFEC86453C3CB21EDBE0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<HE1PR0401MB2538AC4F7C387503A082235FEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<cded7750-a411-3bd8-9728-c86e41d37295@suse.com>
	<HE1PR0401MB2538C6A144D96B2B567B1710EDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
Message-ID: <7a6b0949-d564-8443-c232-b3b76c86b193@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 04/11/2018 07:17 PM, Daniel Sobe wrote:
> Hi Larry,
>
> this is what I was doing. The 2nd node, while being "declared" in the cluster.conf, does not exist yet, and thus everything was happening on one node only.
>
> I do not know in detail how LXC does the mount sharing, but I assume it simply calls "mount --bind /original/mount/point /new/mount/point" in a separate namespace (or, somehow unshares the mount from the original namespace afterwards).
I thought of there is a way to share a directory between host and docker 
container, like
 ?? docker run -v /host/directory:/container/directory -other -options 
image_name command_to_run
That's different from yours.

How did you setup your lxc or container?

If you could, show me the procedure, I'll try to reproduce it.

And by the way, if you get rid of lxc, and just mount ocfs2 on several 
different mount point of local host, will the problem recur?

Regards,
Larry
> Regards,
>
> Daniel
>
