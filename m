From: jim owens <jowens@hp.com>
Date: Tue, 12 May 2009 11:23:08 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <Pine.LNX.4.64.0905120748310.18625@cobra.newdream.net>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<Pine.LNX.4.64.0905120748310.18625@cobra.newdream.net>
Message-ID: <4A09945C.2080002@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sage Weil <sage@newdream.net>
Cc: Joel Becker <Joel.Becker@oracle.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

Sage Weil wrote:
> On Mon, 11 May 2009, Joel Becker wrote:
>> 	Here's v4 of reflink().  If you have the privileges, you get the
>> full snapshot.  If you don't, you must have read access, and then you
>> get the entire snapshot (data and extended attributes) except that the
>> security context is reinitialized.  That's it.  It fits with most of the
>> other ops, and it's a clean degradation.
> 
> What would a 'cp' without '-p' be expected to do here when it has the 
> privileges?  Call reflink(2), then explicitly clear out any copied 
> security attributes ensure that any copied attributes are removed, and 
> otherwise jump through hoops to make the newly created file look like it 
> should?  Should it check whether it has the privileges and act accordingly 
> (_can_ it even do that reliably/atomically?), or unconditionally verify 
> the attributes look like a new file's should?

I don't understand what you think is hard about cp doing the
"if not preserve then update attributes".  It does not have to check
the reflink() attr result, it just assigns the expected new attributes.

Only the -p snapshot needs atomicity.

> To me, a simple 'cp' type operation (assuming it gets wired up the way it 
> could) seems like at least as common a use case than a 'snapshot' 

I don't think changing "cp" is a good idea since users have a
long history that cp means make a data copy, not cow.  Adding
a new flag is IMO not be as good as a new utility.  Particularly
since we can not do directories.

jim
