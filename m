From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 14 Aug 2008 11:51:55 -0700
Subject: [Ocfs2-devel] [Ocfs2-tools-devel] ocfs2-test: fix
	flock_unit_test for fcntl	locks
In-Reply-To: <20080814040612.GH21187@wotan.suse.de>
References: <20080814040612.GH21187@wotan.suse.de>
Message-ID: <20080814185155.GB17664@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 13, 2008 at 09:06:12PM -0700, Mark Fasheh wrote:
> We were expecting a failure for the same-node same-fd trylock tests when in
> fcntl mode, but fcntl locks will actually succeed for this, while flock
> locks won't. The solution is to check which locking mode we're using and
> adjust our expected return accordingly.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>


> 
> Index: ocfs2-test/programs/flock_tests/flock_unit_test.c
> ===================================================================
> --- ocfs2-test/programs/flock_tests/flock_unit_test.c	(revision 183)
> +++ ocfs2-test/programs/flock_tests/flock_unit_test.c	(working copy)
> @@ -329,7 +329,19 @@
>  static void test_1node_1file(char *fname)
>  {
>  	int fd1, fd2;
> +	int trylock_return = 0;
>  
> +	/*
> +	 * flock allows one lock per fd, so a trylock on the 2nd file
> +	 * descriptor will return EWOULDBLOCK.
> +	 *
> +	 * fcntl on the other hand, only allows one lock per process,
> +	 * regardless of the number of fds used. So our trylocks here
> +	 * should succeed as it'll be considered an EX->EX convert.
> +	 */
> +	if (use_flock)
> +		trylock_return = EWOULDBLOCK;
> +
>  	fd1 = get_fd(fname);
>  	fd2 = get_fd(fname);
>  
> @@ -344,13 +356,13 @@
>  
>  	info("Two exclusive trylocks\n");
>  	lock_abort(fname, fd1, 0, 1, 1);
> -	lock_abort(fname, fd2, EWOULDBLOCK, 1, 1);
> +	lock_abort(fname, fd2, trylock_return, 1, 1);
>  	unlock_abort(fname, fd1, 0);
>  
>  
>  	info("One exclusive, one shared trylock\n");
>  	lock_abort(fname, fd1, 0, 1, 0);
> -	lock_abort(fname, fd2, EWOULDBLOCK, 0, 1);
> +	lock_abort(fname, fd2, trylock_return, 0, 1);
>  	unlock_abort(fname, fd1, 0);
>  
>  
> 
> _______________________________________________
> Ocfs2-tools-devel mailing list
> Ocfs2-tools-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-tools-devel

-- 

"You must remember this:
 A kiss is just a kiss,
 A sigh is just a sigh.
 The fundamental rules apply
 As time goes by."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
