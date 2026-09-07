import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.mapreduce.Mapper;

public class WeatherRainfallMapper
        extends Mapper<LongWritable, Text, Text, DoubleWritable> {

    private Text stationKey = new Text();
    private DoubleWritable rainfallValue = new DoubleWritable();

    @Override
    protected void map(
            LongWritable key,
            Text value,
            Context context)
            throws IOException, InterruptedException {

        String line = value.toString();

        if (line.trim().isEmpty()) {
            return;
        }

        String[] fields = line.split(",", -1);

        if (fields.length < 4) {
            return;
        }

        String station = fields[0].trim();
        String element = fields[2].trim();
        String valueString = fields[3].trim();

        // Only PRCP records
        if (!element.equals("PRCP")) {
            return;
        }

        try {
            int rawValue = Integer.parseInt(valueString);

            // Missing value
            if (rawValue == -9999) {
                return;
            }

            // NOAA PRCP = tenths of mm
            double rainfall = rawValue / 10.0;

            stationKey.set(station);
            rainfallValue.set(rainfall);

            context.write(stationKey, rainfallValue);

        } catch (NumberFormatException e) {
            // Invalid numeric value is skipped
        }
    }
}