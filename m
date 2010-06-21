From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 21 Jun 2010 10:08:04 -0700
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <20100621042716.GA2735@laptop.us.oracle.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
	<20100621042716.GA2735@laptop.us.oracle.com>
Message-ID: <4C1F9C74.1060403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/20/2010 09:27 PM, Wengang Wang wrote:
> Hi Goldwyn,
>
> Has you ever test the hit race?
> Actually I also wrote the codes locally monthes ago. When I was testing it,
> I found the dentry are different memory objects. For example, fileA is not
> exist, we issue a command of 'ls -l /path/to/fileA', At the first run, set
> parent ino to dentry. At the second run, the parent ino is not there. By
> printing the address, I found the two dentries are different ones though
> they are both for "fileA".
> So I wonder if you tested it.
>
>    

I am trying to understand your issue.

Do you mean you encountered a case in which there were two
dentries for the same directory entry (/path/to/fileA) but one had
a correct parent inode and the other had no parent inode.

Note that a dentry points to a parent dentry that points to the inode.
So are you claiming that the two dentries pointed to two different parent
dentries one of which had the correct inode the other null inode?

Sunil
