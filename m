From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed, 16 Apr 2008 11:29:22 -0700
Subject: [Ocfs2-devel] dentry locks
In-Reply-To: <20080416182020.GB31299@wotan.suse.de>
References: <48055C53.9090809@oracle.com>
	<20080416182020.GB31299@wotan.suse.de>
Message-ID: <48064582.5020305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Not both in hex. I meant block# in hex and parent in binary.
The only clash this way will be for hard links.

I ran into this while debugging the extra downconvert on dentry locks.
Even if I teach the ocfs2 dissector to handle the dentry lock, I won't
be able to trim down enough the number of tcpdumps to wade thru (using
grep, that is). Block# in hex will help.

Mark Fasheh wrote:
> On Tue, Apr 15, 2008 at 06:54:27PM -0700, Sunil Mushran wrote:
>   
>> Any reason the dentry lock has parent# in string and block# in binary?
>>     
>
> Afair, there were space constraints to printing them both in hex.
> 	--Mark
>
> --
> Mark Fasheh
>   
