# LiveKit Pricing Guide

Understanding LiveKit costs for voice-mode usage.

## LiveKit Cloud Free Tier

Every LiveKit Cloud account includes:
- **10,000 free participant minutes per month**
- No credit card required
- Credits reset on the 1st of each month
- Perfect for personal projects and development

### What are Participant Minutes?

Participant minutes = Number of participants × Minutes in room

Examples:
- 1 person in a room for 60 minutes = 60 participant minutes
- 2 people in a room for 30 minutes = 60 participant minutes
- You + Claude bot = 2 participants

### Free Tier Calculations

With 10,000 free minutes per month:
- **Solo with Claude**: 5,000 minutes (83 hours) per month
- **Daily usage**: ~2.7 hours per day with Claude
- **Multiple devices**: Each connected device counts as a participant

## Usage Scenarios

### Personal Voice Assistant (You + Claude)
- 2 participants per session
- 10,000 ÷ 2 = 5,000 minutes per month
- **~166 hours of conversation per month**

### Testing with Friends (3 participants)
- 3 participants per session
- 10,000 ÷ 3 = 3,333 minutes per month
- **~55 hours of group conversation per month**

### Development Testing
- Frequent short sessions
- Multiple device testing
- Plenty of headroom in free tier

## Paid Tiers

If you exceed the free tier:

### Pay-As-You-Go
- $0.006 per participant minute
- $6 per 1,000 minutes
- No minimum commitment

### Example Monthly Costs
- Light use (20 hours): Free
- Medium use (100 hours): $4.80
- Heavy use (300 hours): $28.80

## Cost Optimization Tips

### 1. Disconnect When Not Using
```javascript
// Disconnect after conversation
"End our voice conversation"
```

### 2. Use Local Development
For unlimited testing:
```bash
make dev  # Run everything locally
```

### 3. Monitor Usage
- Check dashboard at cloud.livekit.io
- Set up usage alerts
- Track participant minutes

### 4. Efficient Testing
- Use sandboxes for quick tests
- Develop locally first
- Only use cloud for remote access

## Comparison with Alternatives

### Local Setup (Free)
- **Cost**: $0
- **Limits**: None
- **Access**: Local network only

### Self-Hosted VPS
- **Cost**: $5-20/month for VPS
- **Limits**: Based on server capacity
- **Access**: Anywhere with setup

### LiveKit Cloud
- **Cost**: Free up to 10,000 minutes
- **Limits**: See above
- **Access**: Global, instant

## Billing FAQ

**Q: What happens if I exceed 10,000 minutes?**
A: Without a payment method, service stops. With payment, you're charged $0.006/minute for overage.

**Q: Do sandboxes count against my free tier?**
A: No, sandboxes have their own temporary allocation.

**Q: Is the free tier permanent?**
A: Currently yes, but check LiveKit's latest pricing.

**Q: How do I track my usage?**
A: Dashboard → Usage → Current Period

## Recommended Approach

For most voice-mode users:

1. **Development**: Use local setup (`make dev`)
2. **Remote Access**: Create one LiveKit Cloud project
3. **Stay Free**: Monitor usage, disconnect when idle
4. **Scale Later**: Add payment method only if needed

With normal personal use, you'll likely never exceed the free tier!