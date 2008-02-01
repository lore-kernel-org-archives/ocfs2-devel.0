From: Jeff Mahoney <jeffm@suse.com>
Date: Fri Feb  1 16:48:35 2008
Subject: [Ocfs2-devel] Re: [patch 0/5] [patch 0/5] Compatibility fixes for
	SLES10
In-Reply-To: <47A398A5.6040804@oracle.com>
References: <20080131204634.478915000@suse.com> <47A398A5.6040804@oracle.com>
Message-ID: <47A3B8A1.1010209@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sunil Mushran wrote:
> While I've not tested it, the patches here look good.
> 
> What about the breakup of the earlier patch? Will it
> be applied atop these?

Hahah, oops. Those are coming. I saw the code in my git tree and thought
you'd applied them as a whole. It turns out I was just being
monumentally stupid, since I had committed them locally to the tree to
generate an easy diff. I thought it curious that the commit log had my
local machines in the email address fields. I'll have those for you over
the weekend. I apparently need more sleep. ;)

- -Jeff

> Jeff Mahoney wrote:
>> Hi guys -
>>
>> I just merged today's git tree against SLES10. There were a few
>> errors and a few warnings that have been there all along. This
>> patch set creates new checks to fix all of them.
>>
>> -Jeff
>>
>> -- 
>> Jeff Mahoney
>> SUSE Labs
>>
>>   
> 


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHo7ihLPWxlyuTD7IRApriAJ92MWOxXj3aXfxRsLzsl+5FN/sANwCfYeLM
n9Yc+DI5Csum2xY0ftnAhGs=
=rOJW
-----END PGP SIGNATURE-----
