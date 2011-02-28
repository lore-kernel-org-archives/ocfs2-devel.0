From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 28 Feb 2011 10:03:02 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTi=3YbbK1ugAP_87HL8FJdOZVKpbJnGM5Y5MdK01@mail.gmail.com>
References: <AANLkTik3387QOadM+-7FaXLT90ednn6+=oDfiyzjt=Tv@mail.gmail.com>
	<20110223093932.GA30720@noexit>
	<AANLkTikZHYK3_BTuS_eOApJnT866t4-HPbRc96jpiWYX@mail.gmail.com>
	<20110223191338.GA4020@noexit>
	<AANLkTimrFoVm11T=Hyq+Uf7wfX8n7zSZStNnAs4sPmvK@mail.gmail.com>
	<20110223211704.GH4020@noexit>
	<AANLkTinmrT4JA4T+0uGHqPgFuyOXbhU0uv9pV=a9wC4y@mail.gmail.com>
	<20110223213730.GK4020@noexit> <20110223214444.GM4020@noexit>
	<AANLkTi=3YbbK1ugAP_87HL8FJdOZVKpbJnGM5Y5MdK01@mail.gmail.com>
Message-ID: <20110228180301.GA13071@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 23, 2011 at 04:31:25PM -0600, Goldwyn Rodrigues wrote:
> Here is a simple script. I will incorporate later into tailtest later.
> 
> FILENAME=/mnt/f2
> 
> for i in `seq 0 256`; do
> 	let s=$i*4096
> 	echo "a" | dd of=$FILENAME count=1 bs=1 seek=$s conv=notrunc 2>/dev/null
> 	let t=$s+4095
> 	echo "b" | dd of=$FILENAME count=1 bs=1 seek=$t conv=notrunc 2>/dev/null
> done

	You shouldn't need to do 256 runs.  I would like to see directed
tests that just hit one spot in a file and expose the corruption.  For
example, your described problem case should work like so:

  # Write the first three blocks of the file, getting us past inline_data
  dd if=/dev/urandom of=$FILENAME count=3 bs=4096
  # Write a byte in the next page
  dd if=/dev/urandom of=$FILENAME count=1 bs=1 seek=12228 conv=notrunc
  # Write after some partial-block portion, trying to expose failed zeroing
  dd if=/dev/urandom of=$FILENAME count=4084 bs=1 seek=12300 conv=notrunc

I would expect this to expose the problem as you've described for
clustersize >= 8K.

Joel

-- 

 Joel's First Law:

	Nature abhors a GUI.

			http://www.jlbec.org/
			jlbec at evilplan.org
