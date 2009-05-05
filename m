From: James Morris <jmorris@namei.org>
Date: Wed, 6 May 2009 08:49:59 +1000 (EST)
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505142102.GE17486@mit.edu>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org> <20090505142102.GE17486@mit.edu>
Message-ID: <alpine.LRH.2.00.0905060836490.9995@tundra.namei.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>
Cc: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org

On Tue, 5 May 2009, Theodore Tso wrote:

> The bigger questions, which we really need to answer are:
> 
> 1) If someone other than the owner of a file uses reflink to "make a
> copy" of the file, is it new inode, with the new inode number, owned
> by the original owner (making it look more like a link), or owned by
> the person creating the reflink (making it look more like a copy).

Changing the owner fundamentally changes the character of the call 
(certainly, the SELinux security logic would be quite different), and I 
think application writers would often be asking "what type of reflink call 
am I supposed to be using here?", and possibly getting it wrong much of 
the time.  It might be better to create a separate syscall for the copy 
case, with its own distinct semantics, if it is desired.


- James
-- 
James Morris
<jmorris@namei.org>
