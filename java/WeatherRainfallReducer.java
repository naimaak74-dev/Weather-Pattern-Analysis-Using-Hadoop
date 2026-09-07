import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class WeatherRainfallReducer
        extends Reducer<Text, DoubleWritable, Text, DoubleWritable> {

    private DoubleWritable result = new DoubleWritable();

    @Override
    protected void reduce(
            Text key,
            Iterable<DoubleWritable> values,
            Context context)
            throws IOException, InterruptedException {

        double sum = 0.0;
        long count = 0;

        for (DoubleWritable value : values) {
            sum += value.get();
            count++;
        }

        if (count > 0) {
            double average = sum / count;

            result.set(average);

            context.write(key, result);
        }
    }
}