From: Ming Lei <ming.lei@canonical.com>
Date: Tue, 19 May 2015 07:25:32 +0800
Subject: [Ocfs2-devel] [Regression] Guest fs corruption with 'block:
 loop: improve performance via blk-mq'
In-Reply-To: <555A7237.1030004@oracle.com>
References: <5557A4EC.6000508@oracle.com>
	<CACVXFVOd9gOte-9t1fgdHq_GYHUHQ8kkBXz2Dzz-J3a7bv50+A@mail.gmail.com>
	<555A2A76.5050701@oracle.com> <555A7237.1030004@oracle.com>
Message-ID: <CACVXFVOxzAAdR8PuN8WBm7WYC8egStV7NFP36X4HsdN4C2T_0g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: santosh shilimkar <santosh.shilimkar@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Tue, May 19, 2015 at 7:13 AM, santosh shilimkar
<santosh.shilimkar@oracle.com> wrote:
> On 5/18/2015 11:07 AM, santosh shilimkar wrote:
>>
>> On 5/17/2015 6:26 PM, Ming Lei wrote:
>>>
>>> Hi Santosh,
>>>
>>> Thanks for your report!
>>>
>>> On Sun, May 17, 2015 at 4:13 AM, santosh shilimkar
>>> <santosh.shilimkar@oracle.com> wrote:
>>>>
>>>> Hi Ming Lei, Jens,
>>>>
>>>> While doing few tests with recent kernels with Xen Server,
>>>> we saw guests(DOMU) disk image getting corrupted while booting it.
>>>> Strangely the issue is seen so far only with disk image over ocfs2
>>>> volume. If the same image kept on the EXT3/4 drive, no corruption
>>>> is observed. The issue is easily reproducible. You see the flurry
>>>> of errors while guest is mounting the file systems.
>>>>
>>>> After doing some debug and bisects, we zeroed down the issue with
>>>> commit "b5dd2f6 block: loop: improve performance via blk-mq". With
>>>> that commit reverted the corruption goes away.
>>>>
>>>> Some more details on the test setup:
>>>> 1. OVM(XEN) Server kernel(DOM0) upgraded to more recent kernel
>>>> which includes commit b5dd2f6. Boot the Server.
>>>> 2. On DOM0 file system create a ocfs2 volume
>>>> 3. Keep the Guest(VM) disk image on ocfs2 volume.
>>>> 4. Boot guest image. (xm create vm.cfg)
>>>
>>>
>>> I am not familiar with xen, so is the image accessed via
>>> loop block inside of guest VM? Is he loop block created
>>> in DOM0 or guest VM?
>>>
>> Guest. The Guest disk image is represented as a file by loop
>> device.
>>
>>>> 5. Observe the VM boot console log. VM itself use the EXT3 fs.
>>>> You will see errors like below and after this boot, that file
>>>> system/disk-image gets corrupted and mostly won't boot next time.
>>>
>>>
>>> OK, that means the image is corrupted by VM booting.
>>>
>> Right
>>
>> [...]
>>
>>>>
>>>>  From the debug of the actual data on the disk vs what is read by
>>>> the guest VM, we suspect the *reads* are actually not going all
>>>> the way to disk and possibly returning the wrong data. Because
>>>> the actual data on ocfs2 volume at those locations seems
>>>> to be non-zero where as the guest seems to be read it as zero.
>>>
>>>
>>> Two big changes in the patchset are: 1) use blk-mq request based IO;
>>> 2) submit I/O concurrently(write vs. write is still serialized)
>>>
>>> Could you apply the patch in below link to see if it can fix the issue?
>>> BTW, this patch only removes concurrent submission.
>>>
>>> http://marc.info/?t=143093223200004&r=1&w=2
>>>
>> What kernel is this patch generated against ? It doesn't apply against
>> v4.0. Does this need the AIO/DIO conversion patches as well. Do you
>> have the dependent patch-set I can't apply it against v4.0.
>>
> Anyways, I created patch(end of the email) against v4.0, based on your patch
> and tested it. The corruption is no more seen so it does fix
> the issue after backing out concurrent submission changes from
> commit b5dd2f6. Let me know whats you plan with it since linus
> tip as well as v4.0 needs this fix.

If your issue is caused by concurrent IO submittion, it might be one
issue of ocfs2. As you see, there isn't such problem for ext3/ext4.

And the single thread patch is introduced for aio/dio support, which
shouldn't have been a fix patch.

Thanks,
Ming

>
> Regards,
> Santosh
>
> [1]
> ---
>  drivers/block/loop.c |   89
> +++++++++++++++++--------------------------------
>  drivers/block/loop.h |    9 ++---
>  2 files changed, 35 insertions(+), 63 deletions(-)
>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 773e964..8484b8a 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -85,8 +85,6 @@ static DEFINE_MUTEX(loop_index_mutex);
>  static int max_part;
>  static int part_shift;
>
> -static struct workqueue_struct *loop_wq;
> -
>  /*
>   * Transfer functions
>   */
> @@ -720,6 +718,23 @@ static void loop_config_discard(struct loop_device *lo)
>         queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
>  }
>
> +static void loop_unprepare_queue(struct loop_device *lo)
> +{
> +       flush_kthread_worker(&lo->worker);
> +       kthread_stop(lo->worker_task);
> +}
> +
> +static int loop_prepare_queue(struct loop_device *lo)
> +{
> +       init_kthread_worker(&lo->worker);
> +       lo->worker_task = kthread_run(kthread_worker_fn,
> +                       &lo->worker, "loop%d", lo->lo_number);
> +       if (IS_ERR(lo->worker_task))
> +               return -ENOMEM;
> +       set_user_nice(lo->worker_task, MIN_NICE);
> +       return 0;
> +}
> +
>  static int loop_set_fd(struct loop_device *lo, fmode_t mode,
>                        struct block_device *bdev, unsigned int arg)
>  {
> @@ -778,6 +793,10 @@ static int loop_set_fd(struct loop_device *lo, fmode_t
> mode,
>         if ((loff_t)(sector_t)size != size)
>                 goto out_putf;
>
> +       error = loop_prepare_queue(lo);
> +       if (error)
> +               goto out_putf;
> +
>         error = 0;
>
>         set_device_ro(bdev, (lo_flags & LO_FLAGS_READ_ONLY) != 0);
> @@ -924,6 +943,8 @@ static int loop_clr_fd(struct loop_device *lo)
>         lo->lo_flags = 0;
>         if (!part_shift)
>                 lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
> +
> +       loop_unprepare_queue(lo);
>         mutex_unlock(&lo->lo_ctl_mutex);
>         /*
>          * Need not hold lo_ctl_mutex to fput backing file.
> @@ -1477,26 +1498,14 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>                 const struct blk_mq_queue_data *bd)
>  {
>         struct loop_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
> +       struct loop_device *lo = cmd->rq->q->queuedata;
>
> -       blk_mq_start_request(bd->rq);
> +       if (lo->lo_state != Lo_bound)
> +               return -EIO;
>
> -       if (cmd->rq->cmd_flags & REQ_WRITE) {
> -               struct loop_device *lo = cmd->rq->q->queuedata;
> -               bool need_sched = true;
> +       blk_mq_start_request(bd->rq);
>
> -               spin_lock_irq(&lo->lo_lock);
> -               if (lo->write_started)
> -                       need_sched = false;
> -               else
> -                       lo->write_started = true;
> -               list_add_tail(&cmd->list, &lo->write_cmd_head);
> -               spin_unlock_irq(&lo->lo_lock);
> -
> -               if (need_sched)
> -                       queue_work(loop_wq, &lo->write_work);
> -       } else {
> -               queue_work(loop_wq, &cmd->read_work);
> -       }
> +       queue_kthread_work(&lo->worker, &cmd->work);
>
>         return BLK_MQ_RQ_QUEUE_OK;
>  }
> @@ -1521,35 +1530,11 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
>         blk_mq_complete_request(cmd->rq);
>  }
>
> -static void loop_queue_write_work(struct work_struct *work)
> -{
> -       struct loop_device *lo =
> -               container_of(work, struct loop_device, write_work);
> -       LIST_HEAD(cmd_list);
>
> -       spin_lock_irq(&lo->lo_lock);
> - repeat:
> -       list_splice_init(&lo->write_cmd_head, &cmd_list);
> -       spin_unlock_irq(&lo->lo_lock);
> -
> -       while (!list_empty(&cmd_list)) {
> -               struct loop_cmd *cmd = list_first_entry(&cmd_list,
> -                               struct loop_cmd, list);
> -               list_del_init(&cmd->list);
> -               loop_handle_cmd(cmd);
> -       }
> -
> -       spin_lock_irq(&lo->lo_lock);
> -       if (!list_empty(&lo->write_cmd_head))
> -               goto repeat;
> -       lo->write_started = false;
> -       spin_unlock_irq(&lo->lo_lock);
> -}
> -
> -static void loop_queue_read_work(struct work_struct *work)
> +static void loop_queue_work(struct kthread_work *work)
>  {
>         struct loop_cmd *cmd =
> -               container_of(work, struct loop_cmd, read_work);
> +               container_of(work, struct loop_cmd, work);
>
>         loop_handle_cmd(cmd);
>  }
> @@ -1561,7 +1546,7 @@ static int loop_init_request(void *data, struct
> request *rq,
>         struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
>
>         cmd->rq = rq;
> -       INIT_WORK(&cmd->read_work, loop_queue_read_work);
> +       init_kthread_work(&cmd->work, loop_queue_work);
>
>         return 0;
>  }
> @@ -1617,9 +1602,6 @@ static int loop_add(struct loop_device **l, int i)
>         }
>         lo->lo_queue->queuedata = lo;
>
> -       INIT_LIST_HEAD(&lo->write_cmd_head);
> -       INIT_WORK(&lo->write_work, loop_queue_write_work);
> -
>         disk = lo->lo_disk = alloc_disk(1 << part_shift);
>         if (!disk)
>                 goto out_free_queue;
> @@ -1858,13 +1840,6 @@ static int __init loop_init(void)
>                 goto misc_out;
>         }
>
> -       loop_wq = alloc_workqueue("kloopd",
> -                       WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_UNBOUND, 0);
> -       if (!loop_wq) {
> -               err = -ENOMEM;
> -               goto misc_out;
> -       }
> -
>         blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
>                                   THIS_MODULE, loop_probe, NULL, NULL);
>
> @@ -1902,8 +1877,6 @@ static void __exit loop_exit(void)
>         blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
>         unregister_blkdev(LOOP_MAJOR, "loop");
>
> -       destroy_workqueue(loop_wq);
> -
>         misc_deregister(&loop_misc);
>  }
>
> diff --git a/drivers/block/loop.h b/drivers/block/loop.h
> index 301c27f..54c6aa5 100644
> --- a/drivers/block/loop.h
> +++ b/drivers/block/loop.h
> @@ -14,7 +14,7 @@
>  #include <linux/blk-mq.h>
>  #include <linux/spinlock.h>
>  #include <linux/mutex.h>
> -#include <linux/workqueue.h>
> +#include <linux/kthread.h>
>  #include <uapi/linux/loop.h>
>
>  /* Possible states of device */
> @@ -54,11 +54,10 @@ struct loop_device {
>         gfp_t           old_gfp_mask;
>
>         spinlock_t              lo_lock;
> -       struct list_head        write_cmd_head;
> -       struct work_struct      write_work;
> -       bool                    write_started;
>         int                     lo_state;
>         struct mutex            lo_ctl_mutex;
> +       struct kthread_worker   worker;
> +       struct task_struct      *worker_task;
>
>         struct request_queue    *lo_queue;
>         struct blk_mq_tag_set   tag_set;
> @@ -66,7 +65,7 @@ struct loop_device {
>  };
>
>  struct loop_cmd {
> -       struct work_struct read_work;
> +       struct kthread_work work;
>         struct request *rq;
>         struct list_head list;
>  };
> --
> 1.7.1
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
