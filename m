From: Andrew Beekhof <abeekhof@suse.de>
Date: Wed, 19 Nov 2008 21:23:10 +0100
Subject: [Ocfs2-devel] New OCF edition of o2cb
In-Reply-To: <20081119181012.GA16192@mail.oracle.com>
References: <02292B9D-C88D-4262-AADF-3820512DC60E@suse.de>
	<20081118231517.GD10451@mail.oracle.com>
	<1E49F7AE-BF12-4D12-8692-730BFDC84341@suse.de>
	<20081119181012.GA16192@mail.oracle.com>
Message-ID: <5D4218FE-BA85-4240-8F23-1FCD779A5566@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Nov 19, 2008, at 7:10 PM, Joel Becker wrote:

> 	Well, if you are just trying to figure out the value to stick in
> /sys/fs/ocfs2/cluster_stack, the answer is "cman", because I wrote  
> those
> bits in ocfs2-tools ;-)

Yeah, but pcmk is the future man :)

>> Np.
>> Do you want to fix that when you commit or shall I resend?
>
> 	Why don't you resend so we don't have me stomping on it?

attached
I'll get together with Lon at some point and get the cman/pcmk auto- 
detection working - will send a patch when its done.

-------------- next part --------------
A non-text attachment was scrubbed...
Name: o2cb.ocf
Type: application/octet-stream
Size: 10885 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081119/0db265cd/attachment.obj 
-------------- next part --------------
