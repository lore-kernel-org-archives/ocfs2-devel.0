From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed, 16 Apr 2008 12:42:31 -0700
Subject: [Ocfs2-devel] dentry locks
In-Reply-To: <20080416191617.GD31299@wotan.suse.de>
References: <48055C53.9090809@oracle.com>	<20080416182020.GB31299@wotan.suse.de>	<48064582.5020305@oracle.com>	<20080416190304.GC31299@wotan.suse.de>	<48064F0B.1040900@oracle.com>
	<20080416191617.GD31299@wotan.suse.de>
Message-ID: <480656A7.8030201@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> Yeah, it breaks the protocol  ;)

I meant, other than that. As in, we can always queue up this change
the next time we break the protocol for a better reason.


> What do the tcp dumps look like? Is it raw binary data, is the binary
> converted into hex, etc?

dentry lock from debugfs: N0000000000000005000d6a02
raw tcpdump: 4e303030303030303030303030303030350000000000000d6a02

N 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 00          0d6a02
4e303030303030303030303030303030350000000000000d6a02

As all other locknames are strings, if I need to wade thru tcpdumps,
I simply grep. If not for that, one can easily spend a day just searching
for the appropriate packets. So this is not a useless exercise.
