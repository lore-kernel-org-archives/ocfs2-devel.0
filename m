From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar  5 10:40:39 2008
Subject: [Ocfs2-devel] Re: [PATCH] Dynamic lockres hash table
In-Reply-To: <47CE065F.6080707@oracle.com>
References: <20080304102448.GB24335@duck.suse.cz> <47CE065F.6080707@oracle.com>
Message-ID: <20080305184021.GT9349@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 04, 2008 at 06:33:03PM -0800, Sunil Mushran wrote:
> My main problem with a mount option is that it is not dynamic.
>
> I was thinking along lines of having a sysfs param that will
> allow users to dynamically resize the number of pages alloted
> to the hash. This will definitely require us running tests to see
> how long it takes to rehash with 500K lockres under the
> dlm_spinlock.

I like the idea of being able to change it on the fly, but I'm wondering
about how useful that ability will be for customers versus just being able
to set it at mount time.


> I guess as a first step, we should add a avg lookup time stat.
>
> But all this will take time.
>
> How about we increase the defaults in 1.4 from 4 pages to 16 or
> even 32 pages. This will be for Enterprise Kernels only and we
> should be able to assume that they will have 128K per mount to
> spare.

Please, can we solve this everywhere instead of having some ocfs2 1.4
specific hack.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
