From: Eric Ren <zren@suse.com>
Date: Thu, 5 Jan 2017 14:30:40 +0800
Subject: [Ocfs2-devel] [PATCH 00/17] ocfs2-test: misc improvements and
	trivial fixes
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1531ae53-098d-5add-deb3-7af808d91182@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

I will push this patches into "suse" branch at Mark's github repo, considering no review 
accepted for more than 2 weeks.
According to Mark's advice, patch can be merged only when it has a review;-)

Thanks,
Eric

On 12/13/2016 01:29 PM, Eric Ren wrote:
> - Misc trivial fixes:
>
> [PATCH 01/17] ocfs2 test: correct the check on testcase if supported
> [PATCH 02/17] Single Run: kernel building is little broken now
> [PATCH 03/17] Trivial: better not to depend on where we issue testing
> [PATCH 04/17] Trivial: fix a typo mistake
> [PATCH 05/17] Trivial: fix checking empty return value
> [PATCH 06/17] multi_mmap: make log messages go to right place
> [PATCH 07/17] lvb_torture: failed when pcmk is used as cluster stack
> [PATCH 08/17] multiple node: pass cross_delete the right log file
>
> - This patches add two more parameters: blocksize and clustersize when we
> kick off a testing, which shortens the run time of a testing round.
> It will keep the old behaviors if they are not specified.
>
> [PATCH 09/17] Single run: make blocksize and clustersize as
> [PATCH 10/17] Multiple run: make blocksize and clustersize as
> [PATCH 11/17] discontig bg: make blocksize and clustersize as
>
> - This patch reflects the mkfs.ocfs2 changes that "--cluster-stack" and
> "--cluster-name" were added.
>
> [PATCH 12/17] Add two cluster-aware parameters: cluster stack and cluster name
>
> - More misc trival fixes:
>
> [PATCH 13/17] Save punch_hole details into logfile for debugging
> [PATCH 14/17] Fix openmpi warning by specifying proper slot number
> [PATCH 15/17] Handle the case when a symbolic link device is given
> [PATCH 16/17] inline data: fix build error
> [PATCH 17/17] discontig bg: give single and multiple node test
>
> Comments and questions are, as always, welcome.
>
> Thanks,
> Eric
>
